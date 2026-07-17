import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/core/theme/tokens/app_radius.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;
  final bool isRead;
  final bool isDark;
  final bool showAvatar;
  final String senderName;
  final bool isEdited;
  final String? messageStatus;
  final String? repliedToId;
  final String? repliedToText;
  final VoidCallback? onTapReply;
  final void Function(BuildContext)? onLongPress;
  final VoidCallback? onSwipeReply;
  final bool selectMode;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onTapRetry;

  const MessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
    required this.isRead,
    required this.isDark,
    required this.showAvatar,
    required this.senderName,
    this.isEdited = false,
    this.messageStatus,
    this.repliedToId,
    this.repliedToText,
    this.onTapReply,
    this.onLongPress,
    this.onSwipeReply,
    this.selectMode = false,
    this.isSelected = false,
    this.onTap,
    this.onTapRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (selectMode && !isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: isSelected ? Colors.teal : Colors.grey.shade500,
                ),
              ),
            ),
          if (!isMe && showAvatar && !selectMode)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.teal.withValues(alpha: 0.2),
                child: Text(
                  senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            )
          else if (!isMe && !selectMode)
            const SizedBox(width: 32),
          if (selectMode && isMe)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: isSelected ? Colors.teal : Colors.grey.shade500,
                ),
              ),
            ),
          Flexible(
            child: GestureDetector(
              onTap: selectMode ? onTap : null,
              onLongPress: selectMode ? null : () => onLongPress?.call(context),
              onHorizontalDragEnd: (details) {
                if (!selectMode &&
                    details.primaryVelocity != null &&
                    details.primaryVelocity! > 300) {
                  onSwipeReply?.call();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                            ? Colors.teal.withValues(alpha: 0.3)
                            : Colors.teal.withValues(alpha: 0.15))
                      : (isMe
                            ? (isDark
                                  ? const Color(0xFF005C4B)
                                  : const Color(0xFFDCF8C6))
                            : (isDark
                                  ? const Color(0xFF1F2C33)
                                  : Colors.white)),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isMe ? 12 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 12),
                  ),
                  border: isMe
                      ? null
                      : Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (repliedToId != null && repliedToText != null)
                      GestureDetector(
                        onTap: onTapReply,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                            border: Border(
                              left: BorderSide(
                                color: isMe
                                    ? (isDark ? Colors.white38 : Colors.black38)
                                    : Colors.teal,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Replied',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isMe
                                      ? (isDark
                                            ? Colors.white60
                                            : Colors.black54)
                                      : Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                repliedToText!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isMe
                                      ? (isDark
                                            ? Colors.white60
                                            : Colors.black54)
                                      : (isDark
                                            ? Colors.white60
                                            : Colors.grey.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        color: isMe
                            ? (isDark ? Colors.white : Colors.black87)
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: isMe
                                ? (isDark ? Colors.white38 : Colors.black45)
                                : Colors.grey.shade500,
                          ),
                        ),
                        if (isEdited) ...[
                          const SizedBox(width: 4),
                          Text(
                            'Edited',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: isMe
                                  ? (isDark ? Colors.white38 : Colors.black45)
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    final status = messageStatus;
    if (status == 'sending') {
      return const SizedBox(
        width: 14,
        height: 14,
        child: CupertinoActivityIndicator(radius: 6),
      );
    }

    if (status == 'failed') {
      return GestureDetector(
        onTap: onTapRetry,
        child: const Icon(Icons.error_outline, size: 16, color: Colors.red),
      );
    }

    if (isRead || status == 'read') {
      return Icon(Icons.done_all, size: 14, color: Colors.teal);
    }

    if (status == 'delivered') {
      return Icon(Icons.done_all, size: 14, color: Colors.grey.shade500);
    }

    return Icon(Icons.done, size: 14, color: Colors.grey.shade500);
  }
}
