import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxs),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (selectMode && !isMe)
            Padding(
              padding: const EdgeInsets.only(right: Spacing.sm),
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.textSubtle,
                ),
              ),
            ),
          if (!isMe && showAvatar && !selectMode)
            Padding(
              padding: const EdgeInsets.only(right: Spacing.sm),
              child: CircleAvatar(
                radius: 12,
                backgroundColor: context.colors.primary.withValues(alpha: 0.2),
                child: Text(
                  senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: context.colors.primary,
                    fontWeight: .bold,
                    fontSize: FontSizeToken.xs,
                  ),
                ),
              ),
            )
          else if (!isMe && !selectMode)
            const SizedBox(width: Spacing.xxxl),
          if (selectMode && isMe)
            Padding(
              padding: const EdgeInsets.only(left: Spacing.sm),
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.textSubtle,
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
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (context.colors.primary.withValues(alpha: 0.15))
                      : (isMe
                            ? (isDark
                                  ? const Color(0xFF005C4B)
                                  : const Color(0xFFDCF8C6))
                            : (context.colors.onPrimary)),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(RadiusToken.lg),
                    topRight: const Radius.circular(RadiusToken.lg),
                    bottomLeft: Radius.circular(isMe ? 12 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 12),
                  ),
                  border: isMe
                      ? null
                      : Border.all(color: context.colors.border),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (repliedToId != null && repliedToText != null)
                      GestureDetector(
                        onTap: onTapReply,
                        child: Container(
                          padding: const EdgeInsets.all(Spacing.sm),
                          margin: const EdgeInsets.only(bottom: Spacing.sm),
                          decoration: BoxDecoration(
                            color: context.colors.text.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(RadiusToken.sm),
                            border: Border(
                              left: BorderSide(
                                color: isMe
                                    ? (context.colors.textSubtle)
                                    : context.colors.primary,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                'Replied',
                                style: TextStyle(
                                  fontSize: FontSizeToken.xs,
                                  fontWeight: .w600,
                                  color: isMe
                                      ? (context.colors.textMuted)
                                      : context.colors.primary,
                                ),
                              ),
                              const SizedBox(height: Spacing.xxs),
                              Text(
                                repliedToText!,
                                maxLines: 2,
                                overflow: .ellipsis,
                                style: TextStyle(
                                  fontSize: FontSizeToken.sm,
                                  color: isMe
                                      ? (context.colors.textMuted)
                                      : (context.colors.textMuted),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: FontSizeToken.lg,
                        color: isMe
                            ? (context.colors.text)
                            : (context.colors.text),
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Row(
                      mainAxisSize: .min,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: FontSizeToken.xs,
                            color: isMe
                                ? (context.colors.textSubtle)
                                : context.colors.textSubtle,
                          ),
                        ),
                        if (isEdited) ...[
                          const SizedBox(width: Spacing.xs),
                          Text(
                            'Edited',
                            style: TextStyle(
                              fontSize: FontSizeToken.xxs,
                              fontStyle: .italic,
                              color: isMe
                                  ? (context.colors.textSubtle)
                                  : context.colors.textSubtle,
                            ),
                          ),
                        ],
                        if (isMe) ...[
                          const SizedBox(width: Spacing.xs),
                          _buildStatusIcon(context),
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

  Widget _buildStatusIcon(BuildContext context) {
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
        child: Icon(
          Icons.error_outline,
          size: 16,
          color: context.colors.danger,
        ),
      );
    }

    if (isRead || status == 'read') {
      return Icon(Icons.done_all, size: 14, color: context.colors.primary);
    }

    if (status == 'delivered') {
      return Icon(Icons.done_all, size: 14, color: context.colors.textSubtle);
    }

    return Icon(Icons.done, size: 14, color: context.colors.textSubtle);
  }
}
