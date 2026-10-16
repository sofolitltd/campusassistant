import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../cache/connectivity_service.dart';
import '../network/api_endpoints.dart';
import '/core/auth/token_store.dart';

/// A general-purpose WebSocket event.
class WebSocketMessage {
  final String type;
  final String? channel;
  final Map<String, dynamic>? data;

  WebSocketMessage({required this.type, this.channel, this.data});

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] as String? ?? '',
      channel: json['channel'] as String?,
      data: json['data'] is Map ? json['data'] as Map<String, dynamic>? : null,
    );
  }
}

/// A singleton WebSocket service for real-time updates.
/// Connects to the backend WebSocket endpoint for community posts,
/// notifications, and other real-time events.
class WebSocketService {
  WebSocketService({Stream<bool>? connectivityChanges}) {
    _connectivitySub = connectivityChanges?.listen(_onConnectivityChanged);
  }

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  final _eventController = StreamController<WebSocketMessage>.broadcast();
  bool _connected = false;
  // Set by disconnect() (logout). Closing the sink fires the stream's onDone,
  // which must not be mistaken for a dropped connection and trigger a
  // reconnect with the logged-out user's token.
  bool _manuallyClosed = false;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  String? _token;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  // The in-flight handshake, so concurrent connect() calls (auth listener,
  // resume, connectivity) share it instead of opening a second channel.
  Future<void>? _connecting;
  // Bumped by disconnect(): a handshake started before it compares this on
  // completion and discards its socket, even if a new connect() (fast
  // logout → login) has since cleared _manuallyClosed.
  int _generation = 0;
  StreamSubscription<bool>? _connectivitySub;
  // Only an explicit "offline" event turns this off: ConnectivityService
  // reports false until its first check, which must not block connecting.
  bool _online = true;
  final _random = Random();

  Stream<WebSocketMessage> get messages => _eventController.stream;
  bool get isConnected => _connected;

  /// Connect to the WebSocket server. Calls made while a handshake is in
  /// flight wait for that one.
  Future<void> connect(String token) {
    if (_connected) return Future.value();
    final inFlight = _connecting;
    if (inFlight != null) return inFlight;
    late final Future<void> attempt;
    attempt = _connect(token).whenComplete(() {
      // A disconnect() + new connect() may have replaced it meanwhile.
      if (identical(_connecting, attempt)) _connecting = null;
    });
    return _connecting = attempt;
  }

  Future<void> _connect(String token) async {
    final generation = _generation;
    _manuallyClosed = false;
    _token = token;

    final uri = _buildUri(token);
    try {
      await _subscription?.cancel();
      _subscription = null;
      final channel = WebSocketChannel.connect(uri);
      _channel = channel;
      await channel.ready;

      // disconnect() ran while the handshake was in flight — drop this socket.
      if (_manuallyClosed || generation != _generation) {
        await channel.sink.close();
        if (identical(_channel, channel)) _channel = null;
        return;
      }

      _connected = true;
      _reconnectAttempts = 0;

      _subscription = channel.stream.listen(
        (data) {
          try {
            final json = jsonDecode(data as String) as Map<String, dynamic>;
            _eventController.add(WebSocketMessage.fromJson(json));
          } catch (e) {
            debugPrint('[WS] Failed to parse message: $e');
          }
        },
        onDone: () {
          _connected = false;
          if (!_manuallyClosed) _scheduleReconnect();
        },
        onError: (error) {
          debugPrint('[WS] Error: $error');
          _connected = false;
          if (!_manuallyClosed) _scheduleReconnect();
        },
      );

      // Start heartbeat
      _startHeartbeat();

      debugPrint('[WS] Connected');
    } catch (e) {
      debugPrint('[WS] Connection failed: $e');
      _connected = false;
      if (!_manuallyClosed) _scheduleReconnect();
    }
  }

  /// Subscribe to a specific channel (e.g., 'community', 'notifications').
  void subscribe(String channel) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode({'action': 'subscribe', 'channel': channel}));
  }

  /// Unsubscribe from a channel.
  void unsubscribe(String channel) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(
      jsonEncode({'action': 'unsubscribe', 'channel': channel}),
    );
  }

  /// Send a message to the server.
  void send(Map<String, dynamic> data) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode(data));
  }

  /// Disconnect from the WebSocket server.
  Future<void> disconnect() async {
    _manuallyClosed = true;
    _generation++;
    _connecting = null;
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _connected = false;
    _token = null;
    _reconnectAttempts = 0;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
  }

  /// Reconnect if not already connected (app resume, network back). Starts
  /// the backoff over, so a socket that gave up after
  /// [_maxReconnectAttempts] gets a fresh set of tries.
  Future<void> reconnectIfNeeded() async {
    if (_connected || _token == null || _manuallyClosed) return;
    _reconnectTimer?.cancel();
    _reconnectAttempts = 0;
    await _reconnectWithFreshToken();
  }

  void _onConnectivityChanged(bool online) {
    _online = online;
    if (online) {
      reconnectIfNeeded();
    } else {
      // Retrying with no network only burns attempts; the online event above
      // reconnects instead.
      _reconnectTimer?.cancel();
    }
  }

  void _scheduleReconnect() {
    if (_manuallyClosed || _token == null || !_online) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('[WS] Max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    // Linear 3s..30s backoff with equal jitter (50–100% of the step), so
    // clients dropped by the same server restart don't all return at once.
    final stepMs = (3000 * (_reconnectAttempts + 1)).clamp(3000, 30000);
    final delay = Duration(
      milliseconds: stepMs ~/ 2 + _random.nextInt(stepMs ~/ 2 + 1),
    );
    _reconnectAttempts++;

    debugPrint(
      '[WS] Reconnecting in ${delay.inMilliseconds}ms '
      '(attempt $_reconnectAttempts)',
    );
    _reconnectTimer = Timer(delay, () {
      if (!_manuallyClosed && _token != null) _reconnectWithFreshToken();
    });
  }

  /// Re-reads the current access token before reconnecting.
  /// The token cached in [_token] can go stale (access tokens are
  /// short-lived); reusing it would make every reconnect attempt fail
  /// with the same auth error forever once it expires. No token in storage
  /// means the user logged out, so there is nothing to reconnect as.
  Future<void> _reconnectWithFreshToken() async {
    final freshToken = await TokenStore.instance.getAccessToken();
    if (_manuallyClosed || freshToken == null || freshToken.isEmpty) return;
    await connect(freshToken);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      send({'type': 'ping'});
    });
  }

  Uri _buildUri(String token) {
    final base = ApiEndpoints.baseUrl;
    final host = base
        .replaceFirst('https://', '')
        .replaceFirst('http://', '')
        .replaceFirst('/api/v1', '');
    final isSecure = base.startsWith('https://');
    final scheme = isSecure ? 'wss' : 'ws';
    return Uri.parse('$scheme://$host/ws/notifications')
        .replace(queryParameters: {'token': token});
  }

  void dispose() {
    _connectivitySub?.cancel();
    disconnect();
    _eventController.close();
  }
}

/// Riverpod provider for the WebSocket service.
final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService(
    connectivityChanges: ref
        .watch(connectivityServiceProvider)
        .onConnectivityChanged,
  );
  ref.onDispose(() => service.dispose());
  return service;
});

/// Stream provider that exposes incoming WebSocket messages.
final websocketMessagesProvider = StreamProvider<WebSocketMessage>((ref) {
  final service = ref.watch(websocketServiceProvider);
  return service.messages;
});

/// Notifier that tracks WebSocket connection status.
class WebSocketConnectedNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void update(bool value) => state = value;
}

final websocketConnectedProvider =
    NotifierProvider<WebSocketConnectedNotifier, bool>(
      WebSocketConnectedNotifier.new,
    );
