import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../network/api_endpoints.dart';


/// A general-purpose WebSocket event.
class WebSocketMessage {
  final String type;
  final String? channel;
  final Map<String, dynamic>? data;

  WebSocketMessage({
    required this.type,
    this.channel,
    this.data,
  });

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
  WebSocketChannel? _channel;
  final _eventController = StreamController<WebSocketMessage>.broadcast();
  bool _connected = false;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  String? _token;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;

  Stream<WebSocketMessage> get messages => _eventController.stream;
  bool get isConnected => _connected;

  /// Connect to the WebSocket server.
  Future<void> connect(String token) async {
    if (_connected) return;
    _token = token;

    final uri = _buildUri(token);
    try {
      _channel = WebSocketChannel.connect(uri);
      _connected = true;
      _reconnectAttempts = 0;

      _channel!.stream.listen(
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
          _scheduleReconnect();
        },
        onError: (error) {
          debugPrint('[WS] Error: $error');
          _connected = false;
          _scheduleReconnect();
        },
      );

      // Start heartbeat
      _startHeartbeat();

      debugPrint('[WS] Connected');
    } catch (e) {
      debugPrint('[WS] Connection failed: $e');
      _connected = false;
      _scheduleReconnect();
    }
  }

  /// Subscribe to a specific channel (e.g., 'community', 'notifications').
  void subscribe(String channel) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode({
      'action': 'subscribe',
      'channel': channel,
    }));
  }

  /// Unsubscribe from a channel.
  void unsubscribe(String channel) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode({
      'action': 'unsubscribe',
      'channel': channel,
    }));
  }

  /// Send a message to the server.
  void send(Map<String, dynamic> data) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode(data));
  }

  /// Disconnect from the WebSocket server.
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _connected = false;
    await _channel?.sink.close();
    _channel = null;
  }

  /// Reconnect if not already connected.
  Future<void> reconnectIfNeeded() async {
    if (!_connected && _token != null) {
      await connect(_token!);
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('[WS] Max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = Duration(seconds: (3 * (_reconnectAttempts + 1)).clamp(3, 30));
    _reconnectAttempts++;

    debugPrint('[WS] Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)');
    _reconnectTimer = Timer(delay, () {
      if (_token != null) connect(_token!);
    });
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
    disconnect();
    _eventController.close();
  }
}

/// Riverpod provider for the WebSocket service.
final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
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

final websocketConnectedProvider = NotifierProvider<WebSocketConnectedNotifier, bool>(
  WebSocketConnectedNotifier.new,
);
