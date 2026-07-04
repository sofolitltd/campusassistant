enum ItemKind { date, message }

class ChatItem {
  final ItemKind kind;
  final Map<String, dynamic>? data;
  final String? date;
  const ChatItem({required this.kind, this.data, this.date});
}
