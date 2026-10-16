import 'dart:convert';
import 'dart:typed_data';

import 'package:campusassistant/core/cache/cache_manager.dart';
import 'package:campusassistant/core/cache/connectivity_service.dart';
import 'package:campusassistant/core/cache/sync_manager.dart';
import 'package:campusassistant/core/database/app_database.dart';
import 'package:campusassistant/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeConnectivity extends ConnectivityService {
  bool connected = true;

  @override
  bool get isConnected => connected;
}

/// Replies per path; a missing path is a connection error.
class _FakeAdapter implements HttpClientAdapter {
  final Map<String, int> statusByPath;
  final requests = <String>[];

  _FakeAdapter(this.statusByPath);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add('${options.method} ${options.path}');
    final status = statusByPath[options.path];
    if (status == null) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    return ResponseBody.fromString(
      jsonEncode({}),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late OfflineDatabase db;
  late _FakeConnectivity connectivity;
  late ApiClient api;
  late SyncManager sync;

  setUp(() {
    db = OfflineDatabase(NativeDatabase.memory());
    connectivity = _FakeConnectivity();
    api = ApiClient(baseUrl: 'https://api.test', getToken: () async => null);
    sync = SyncManager(
      db: db,
      apiClient: api,
      connectivity: connectivity,
      cacheManager: CacheManager(db),
    );
  });

  tearDown(() => db.close());

  Future<void> enqueue(String endpoint, {String method = 'POST'}) =>
      db.enqueueSync(
        operation: 'create',
        entityType: 'test',
        entityKey: endpoint,
        payload: {'k': 'v'},
        endpoint: endpoint,
        method: method,
      );

  test('sends queued writes in order and removes them', () async {
    final adapter = _FakeAdapter({'/a': 200, '/b': 201});
    api.dio.httpClientAdapter = adapter;
    await enqueue('/a');
    await enqueue('/b', method: 'PUT');

    await sync.processPendingSyncs();

    expect(adapter.requests, ['POST /a', 'PUT /b']);
    expect(await db.getPendingSyncs(), isEmpty);
  });

  test('does nothing while offline', () async {
    final adapter = _FakeAdapter({'/a': 200});
    api.dio.httpClientAdapter = adapter;
    connectivity.connected = false;
    await enqueue('/a');

    await sync.processPendingSyncs();

    expect(adapter.requests, isEmpty);
    expect(await db.getPendingSyncs(), hasLength(1));
  });

  test('a 4xx is dead-lettered immediately', () async {
    api.dio.httpClientAdapter = _FakeAdapter({'/a': 422});
    await enqueue('/a');

    await sync.processPendingSyncs();

    expect(await db.getPendingSyncs(), isEmpty);
    expect(await db.getPendingSyncCount(), 0);
  });

  test('a 500 stays pending until maxRetries, then dead-letters', () async {
    api.dio.httpClientAdapter = _FakeAdapter({'/a': 500});
    await enqueue('/a');

    for (var i = 1; i < SyncManager.maxRetries; i++) {
      await sync.processPendingSyncs();
      final pending = await db.getPendingSyncs();
      expect(pending.single.retryCount, i);
    }
    await sync.processPendingSyncs();
    expect(await db.getPendingSyncs(), isEmpty);
  });

  test(
    'a network failure stops the pass without counting an attempt',
    () async {
      // '/a' is unmapped, so the fake throws a connection error for it.
      final adapter = _FakeAdapter({'/b': 200});
      api.dio.httpClientAdapter = adapter;
      await enqueue('/a');
      await enqueue('/b');

      await sync.processPendingSyncs();

      expect(adapter.requests, ['POST /a']);
      final pending = await db.getPendingSyncs();
      expect(pending, hasLength(2));
      expect(pending.every((p) => p.retryCount == 0), isTrue);
    },
  );
}
