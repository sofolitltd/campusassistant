import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/inbox/presentation/providers/chat_providers.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class RequestConfirmationPage extends ConsumerWidget {
  final String conversationId;
  final String name;
  final String otherUserId;
  final String? initiatorId;

  const RequestConfirmationPage({
    super.key,
    required this.conversationId,
    required this.name,
    required this.otherUserId,
    this.initiatorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider(conversationId));

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Scaffold(
          backgroundColor: context.colors.surfaceAlt,
          appBar: AppBar(
            backgroundColor: context.colors.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Message Request',
              style: GoogleFonts.outfit(
                fontWeight: .w600,
                fontSize: FontSizeToken.lg,
              ),
            ),
          ),
          body: messagesAsync.when(
            data: (messages) {
              final msg = messages.isNotEmpty ? messages.last : null;
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Spacing.xxl),
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: context.colors.warning.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: context.colors.warning,
                            fontWeight: .bold,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontWeight: .w600,
                          fontSize: FontSizeToken.xxl,
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(RadiusToken.xxl),
                        ),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Icon(
                              LucideIcons.mailQuestion,
                              size: 14,
                              color: context.colors.warning,
                            ),
                            SizedBox(width: Spacing.xs),
                            Text(
                              'Message Request',
                              style: TextStyle(
                                fontSize: FontSizeToken.sm,
                                color: context.colors.warning,
                                fontWeight: .w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xxxl),
                      if (msg != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(Spacing.lg),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: BorderRadius.circular(RadiusToken.md),
                            border: Border.all(color: context.colors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.messageCircle,
                                    size: 16,
                                    color: context.colors.textSubtle,
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Text(
                                    'Message',
                                    style: TextStyle(
                                      fontSize: FontSizeToken.sm,
                                      color: context.colors.textSubtle,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.sm),
                              Text(
                                msg['text'] as String? ?? '',
                                style: TextStyle(
                                  fontSize: FontSizeToken.lg,
                                  color: context.colors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Spacing.xxxl),
                      ],
                      Text(
                        'Accepting will move this conversation to your inbox.',
                        textAlign: .center,
                        style: TextStyle(
                          fontSize: FontSizeToken.md,
                          color: context.colors.textSubtle,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxl),
                      SizedBox(
                        width: double.infinity,
                        height: ControlToken.height,
                        child: ElevatedButton(
                          onPressed: () => _handleAccept(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: context.colors.onPrimary,
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: FontSizeToken.lg,
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      SizedBox(
                        width: double.infinity,
                        height: ControlToken.height,
                        child: OutlinedButton(
                          onPressed: () => _handleBlock(context, ref),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.colors.danger,
                            side: BorderSide(color: context.colors.danger),
                          ),
                          child: const Text(
                            'Block',
                            style: TextStyle(
                              fontSize: FontSizeToken.lg,
                              fontWeight: .w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Not now',
                          style: TextStyle(color: context.colors.textSubtle),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }

  void _handleAccept(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      await repo.acceptRequest(conversationId);
      ref.read(conversationsRefreshProvider.notifier).trigger();
      if (context.mounted) {
        Navigator.of(context).pop();
        context.pushNamed(
          AppRoute.inboxChat.name,
          pathParameters: {'conversationId': conversationId},
          extra: {
            'name': name,
            'otherUserId': otherUserId,
            'status': 'accepted',
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to accept: $e')));
      }
    }
  }

  void _handleBlock(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      await repo.blockRequest(conversationId);
      ref.read(conversationsRefreshProvider.notifier).trigger();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Request blocked')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to block: $e')));
      }
    }
  }
}
