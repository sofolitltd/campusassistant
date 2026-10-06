import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final VoidCallback onSend;
  final bool isSending;
  final bool hasText;
  final bool isMultiline;

  const ChatInput({
    super.key,
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
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.xs,
        Spacing.md,
        Spacing.md,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
        decoration: BoxDecoration(
          color: isDark ? Colors.transparent : context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.xxxl),
          border: Border.all(color: context.colors.borderStrong),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: isMultiline
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          children: [
            Align(
              alignment: isMultiline
                  ? Alignment.bottomCenter
                  : Alignment.center,
              child: IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: context.colors.textMuted,
                  size: 22,
                ),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: .newline,
                minLines: 1,
                maxLines: 5,
                keyboardType: .multiline,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: FontSizeToken.lg,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: context.colors.textSubtle,
                    fontSize: FontSizeToken.lg,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: Spacing.md,
                  ),
                ),
              ),
            ),
            Align(
              alignment: isMultiline
                  ? Alignment.bottomCenter
                  : Alignment.center,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(right: Spacing.xs),
                decoration: BoxDecoration(
                  color: canSend
                      ? context.colors.primary
                      : context.colors.textSubtle,
                  borderRadius: BorderRadius.circular(RadiusToken.xxl),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: isSending
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CupertinoActivityIndicator(
                            color: context.colors.onPrimary,
                          ),
                        )
                      : Icon(
                          Icons.arrow_upward_rounded,
                          color: context.colors.onPrimary,
                          size: 16,
                        ),
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
