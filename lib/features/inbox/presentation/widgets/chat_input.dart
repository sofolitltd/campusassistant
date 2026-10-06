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
    final c = context.colors;
    final canSend = hasText && !isSending;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.md,
          Spacing.sm,
          Spacing.md,
          Spacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(
                    isMultiline ? RadiusToken.xl : RadiusToken.xxxl,
                  ),
                  border: Border.all(color: c.border),
                  boxShadow: [
                    BoxShadow(
                      color: c.shadow.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  textInputAction: .newline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: .multiline,
                  style: TextStyle(color: c.text, fontSize: FontSizeToken.lg),
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(
                      color: c.textSubtle,
                      fontSize: FontSizeToken.lg,
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: Spacing.md,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Material(
              color: canSend ? c.primary : c.border,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: canSend ? onSend : null,
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Center(
                    child: isSending
                        ? CupertinoActivityIndicator(color: c.onPrimary)
                        : Icon(
                            Icons.arrow_upward_rounded,
                            color: canSend ? c.onPrimary : c.textSubtle,
                            size: 22,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
