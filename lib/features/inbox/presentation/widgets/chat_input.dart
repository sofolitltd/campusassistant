import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final VoidCallback onSend;
  final bool isSending;
  final bool hasText;
  final bool isMultiline;

  const ChatInput({super.key, 
    required this.controller,
    required this.isDark,
    required this.onSend,
    required this.isSending,
    required this.hasText,
    required this.isMultiline,
  });

  @override
  Widget build(BuildContext context) {
    final canSend = hasText && !isSending;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: isMultiline ? CrossAxisAlignment.end : CrossAxisAlignment.center,
          children: [
            Align(
              alignment: isMultiline ? Alignment.bottomCenter : Alignment.center,
              child: IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                  size: 22,
                ),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            Align(
              alignment: isMultiline ? Alignment.bottomCenter : Alignment.center,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: canSend ? Colors.teal : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: isSending
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 16),
                  onPressed: canSend ? onSend : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
