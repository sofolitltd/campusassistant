import 'dart:convert';
import 'dart:typed_data';

import 'package:campusassistant/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers each request with whatever [handler] returns, and records it.
class _FakeAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;
  final requests = <RequestOptions>[];

  /// Snapshot per request: a retry re-sends the same (mutated) options object.
  final authHeaders = <Object?>[];

  _FakeAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    authHeaders.add(options.headers['Authorization']);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, [Object body = const {}]) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  group('401 refresh', () {
    test('refreshes once and retries with the new token', () async {
      var token = 'old';
      var refreshes = 0;
      final client = ApiClient(
        baseUrl: 'https://api.test',
        getToken: () async => token,
        onUnauthorized: () async {
          refreshes++;
          token = 'new';
          return true;
        },
      );
      final adapter = _FakeAdapter(
        (o) async => o.headers['Authorization'] == 'Bearer new'
            ? _json(200, {'ok': true})
            : _json(401),
      );
      client.dio.httpClientAdapter = adapter;

      final res = await client.get('/me');

      expect(res.data, {'ok': true});
      expect(refreshes, 1);
      expect(adapter.authHeaders, ['Bearer old', 'Bearer new']);
    });

    test('concurrent 401s share a single refresh', () async {
      var token = 'old';
      var refreshes = 0;
      final client = ApiClient(
        baseUrl: 'https://api.test',
        getToken: () async => token,
        onUnauthorized: () async {
          refreshes++;
          await Future<void>.delayed(const Duration(milliseconds: 20));
          token = 'new';
          return true;
        },
      );
      client.dio.httpClientAdapter = _FakeAdapter(
        (o) async => o.headers['Authorization'] == 'Bearer new'
            ? _json(200)
            : _json(401),
      );

      final results = await Future.wait([
        client.get('/a'),
        client.get('/b'),
        client.get('/c'),
      ]);

      expect(results.map((r) => r.statusCode), [200, 200, 200]);
      expect(refreshes, 1);
    });

    test('surfaces the 401 when refresh fails', () async {
      final client = ApiClient(
        baseUrl: 'https://api.test',
        getToken: () async => 'old',
        onUnauthorized: () async => false,
      );
      client.dio.httpClientAdapter = _FakeAdapter((_) async => _json(401));

      await expectLater(
        client.get('/me'),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            401,
          ),
        ),
      );
    });

    test('never refreshes for the login endpoint', () async {
      var refreshes = 0;
      final client = ApiClient(
        baseUrl: 'https://api.test',
        getToken: () async => null,
        onUnauthorized: () async {
          refreshes++;
          return true;
        },
      );
      client.dio.httpClientAdapter = _FakeAdapter((_) async => _json(401));

      await expectLater(
        client.post('/auth/login'),
        throwsA(isA<DioException>()),
      );
      expect(refreshes, 0);
    });
  });

  group('GET retry', () {
    test('retries a transient 503 and then succeeds', () async {
      final client = ApiClient(
        baseUrl: 'https://api.test',
        getToken: () async => null,
      );
      var calls = 0;
      client.dio.httpClientAdapter = _FakeAdapter(
        (_) async => ++calls == 1 ? _json(503) : _json(200),
      );

      final res = await client.get('/list');

      expect(res.statusCode, 200);
      expect(calls, 2);
    });

    test('does not retry a POST or a 4xx', () async {
      final client = ApiClient(
        baseUrl: 'https://api.test',
        getToken: () async => null,
      );
      final adapter = _FakeAdapter(
        (o) async => o.method == 'POST' ? _json(503) : _json(404),
      );
      client.dio.httpClientAdapter = adapter;

      await expectLater(client.post('/x'), throwsA(isA<DioException>()));
      await expectLater(client.get('/y'), throwsA(isA<DioException>()));
      expect(adapter.requests, hasLength(2));
    });
  });
}
