import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '/core/network/api_endpoints.dart';
import '/features/auth/data/datasources/auth_local_data_source.dart';

class ChatWebSocketEvent {
  final String type;
  final String? conversationId;
  final String? userId;
  final Map<String, dynamic>? message;
  final String? messageId;
  final String? text;
  final bool? isTyping;
  final String? senderName;

  ChatWebSocketEvent({
    required this.type,
    this.conversationId,
    this.userId,
    this.message,
    this.messageId,
    this.text,
    this.isTyping,
    this.senderName,
  });

  factory ChatWebSocketEvent.fromJson(Map<String, dynamic> json) {
    return ChatWebSocketEvent(
      type: json['type'] as String? ?? '',
      conversationId: json['conversationId'] as String?,
      userId: json['userId'] as String?,
      message: json['message'] is Map
          ? json['message'] as Map<String, dynamic>?
          : null,
      messageId: json['messageId'] as String?,
      text: json['text'] as String?,
      isTyping: json['isTyping'] as bool?,
      senderName: json['senderName'] as String?,
    );
  }
}

class ChatWebSocketService {
  WebSocketChannel? _channel;
  final _eventController = StreamController<ChatWebSocketEvent>.broadcast();
  bool _connected = false;
  Timer? _reconnectTimer;

  Stream<ChatWebSocketEvent> get events => _eventController.stream;
  bool get isConnected => _connected;

  static Uri _wsUri(String conversationId, String token) {
    final base = ApiEndpoints.baseUrl;
    final host = base
        .replaceFirst('https://', '')
        .replaceFirst('http://', '')
        .replaceFirst('/api/v1', '');
    final isSecure = base.startsWith('https://');
    final scheme = isSecure ? 'wss' : 'ws';
    return Uri.parse(
      '$scheme://$host/ws/chat/$conversationId',
    ).replace(queryParameters: {'token': token});
  }

  Future<void> connect(String conversationId) async {
    await disconnect();

    final storage = FlutterSecureStorage();
    final token = await storage.read(
      key: AuthLocalDataSourceImpl.cachedTokenKey,
    );
    if (token == null || token.isEmpty) return;

    final uri = _wsUri(conversationId, token);
    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;
      _connected = true;

      _channel!.stream.listen(
        (data) {
          try {
            final json = jsonDecode(data as String) as Map<String, dynamic>;
            _eventController.add(ChatWebSocketEvent.fromJson(json));
          } catch (_) {}
        },
        onDone: () {
          _connected = false;
          _scheduleReconnect(conversationId);
        },
        onError: (_) {
          _connected = false;
          _scheduleReconnect(conversationId);
        },
      );
    } catch (_) {
      _connected = false;
      _scheduleReconnect(conversationId);
    }
  }

  void _scheduleReconnect(String conversationId) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connect(conversationId);
    });
  }

  void sendTyping() {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode({'type': 'typing'}));
  }

  void sendMarkRead(String conversationId) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(
      jsonEncode({'type': 'mark_read', 'conversationId': conversationId}),
    );
  }

  void send(Map<String, dynamic> data) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode(data));
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _connected = false;
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
