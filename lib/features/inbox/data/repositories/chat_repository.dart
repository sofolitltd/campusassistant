import '/core/network/api_client.dart';
import '/core/network/api_endpoints.dart';

class Contact {
  final String userId;
  final String name;
  final String? avatarUrl;

  const Contact({
    required this.userId,
    required this.name,
    this.avatarUrl,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      userId: json['userId'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository(this._apiClient);

  Future<({List<Contact> contacts, int total})> getContacts({
    int limit = 20,
    int offset = 0,
    String? search,
  }) async {
    final params = <String, dynamic>{'limit': limit, 'offset': offset};
    if (search != null && search.isNotEmpty) params['search'] = search;
    final response = await _apiClient.get(
      ApiEndpoints.conversationsContacts,
      queryParameters: params,
    );
    final data = response.data as Map<String, dynamic>;
    final list = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final contacts = list.map((e) => Contact.fromJson(e)).toList();
    final total = (data['total'] as num?)?.toInt() ?? 0;
    return (contacts: contacts, total: total);
  }

  Future<List<Map<String, dynamic>>> getConversations() async {
    final response = await _apiClient.get(ApiEndpoints.conversations);
    final data = response.data;
    if (data is Map && data['conversations'] is List) {
      return List<Map<String, dynamic>>.from(data['conversations']);
    }
    return [];
  }

  Future<Map<String, dynamic>> getOrCreateConversation({
    required String otherUserId,
    required String otherUserName,
    String? otherUserImage,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.conversations,
      data: {
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
        'otherUserImage': ?otherUserImage,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMessages(
    String conversationId, {
    String? cursor,
    int limit = 30,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (cursor != null) params['cursor'] = cursor;
    final response = await _apiClient.get(
      ApiEndpoints.conversationMessages(conversationId),
      queryParameters: params,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String text,
    String? repliedToId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.conversationMessages(conversationId),
      data: {
        'text': text,
        'repliedToId': ?repliedToId,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> editMessage({
    required String conversationId,
    required String messageId,
    required String text,
  }) async {
    await _apiClient.put(
      ApiEndpoints.conversationMessage(conversationId, messageId),
      data: {'text': text},
    );
  }

  Future<List<Map<String, dynamic>>> getPendingConversations() async {
    final response = await _apiClient.get(ApiEndpoints.conversationsPending);
    final data = response.data;
    if (data is Map && data['conversations'] is List) {
      return List<Map<String, dynamic>>.from(data['conversations']);
    }
    return [];
  }

  Future<void> acceptRequest(String conversationId) async {
    await _apiClient.post(ApiEndpoints.conversationAccept(conversationId));
  }

  Future<void> blockRequest(String conversationId) async {
    await _apiClient.post(ApiEndpoints.conversationBlock(conversationId));
  }

  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async {
    await _apiClient.delete(
      ApiEndpoints.conversationMessageDelete(conversationId, messageId),
    );
  }

  Future<void> deleteConversation(String conversationId) async {
    await _apiClient.delete(
      ApiEndpoints.conversationDelete(conversationId),
    );
  }

  Future<void> archiveConversation(String conversationId) async {
    await _apiClient.post(
      ApiEndpoints.conversationArchive(conversationId),
    );
  }

  Future<void> markAsRead(String conversationId) async {
    try {
      await _apiClient.post(ApiEndpoints.conversationRead(conversationId));
    } catch (_) {}
  }
}
