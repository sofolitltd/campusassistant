import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/pdf_tabs/domain/pdf_tab.dart';
import '/features/pdf_tabs/presentation/providers/pdf_tabs_provider.dart';

/// Chrome-style "tab group" switcher — a bottom sheet with one large card
/// per open PDF tab (preview + title + close button). Replaces the always-
/// visible bottom tab bar so the PDF viewport only gives up space when the
/// user actually asks to switch tabs.
Future<void> showPdfTabSwitcherSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PdfTabSwitcherSheet(),
  );
}

class _PdfTabSwitcherSheet extends ConsumerWidget {
  const _PdfTabSwitcherSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pdfTabsProvider);
    final tabs = state.tabs;

    // Fixed at half the screen regardless of how many tabs are open (up to
    // the 4-tab max) — so the sheet always reads as a deliberate "tab
    // switcher" surface, and a 2x2 grid of up to 4 cards fits without the
    // user needing to scroll.
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.64,
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxl),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.sm),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: RadiusToken.circular(RadiusToken.full),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.md,
                  Spacing.lg,
                  Spacing.sm,
                ),
                child: Row(
                  children: [
                    Text(
                      'Open File (${tabs.length})',
                      style: TextStyle(
                        fontWeight: .bold,
                        fontSize: FontSizeToken.lg,
                        color: context.colors.text,
                      ),
                    ),

                    // add x btn
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        LucideIcons.x,
                        size: 20,
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.xs,
                    Spacing.lg,
                    Spacing.lg,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: Spacing.md,
                    crossAxisSpacing: Spacing.md,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    final tab = tabs[index];
                    return _TabCard(
                      tab: tab,
                      active: tab.url == state.activeUrl,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabCard extends ConsumerWidget {
  final PdfTab tab;
  final bool active;

  const _TabCard({required this.tab, required this.active});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: RadiusToken.circular(RadiusToken.lg),
      onTap: () {
        ref.read(pdfTabsProvider.notifier).setActive(tab.url);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceAlt,
          borderRadius: RadiusToken.circular(RadiusToken.lg),
          border: Border.all(
            color: active ? context.colors.primary : context.colors.border,
            width: active ? 2 : 1,
          ),
        ),
        clipBehavior: .antiAlias,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(RadiusToken.lg),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: (tab.thumbnailUrl?.isNotEmpty ?? false)
                          ? Image.network(
                              tab.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  _previewFallback(context),
                            )
                          : _previewFallback(context),
                    ),
                    Positioned(
                      top: Spacing.xs,
                      right: Spacing.xs,
                      child: GestureDetector(
                        onTap: () {
                          // Closing the last tab makes [PdfTabsPage] pop
                          // itself (see its ref.listen), but that pop call
                          // would otherwise just dismiss this still-open
                          // sheet instead (it's the topmost route) and leave
                          // PdfTabsPage stranded on an empty, blank body.
                          // Closing the sheet first means the state-change
                          // pop lands on the right route.
                          final isLastTab =
                              ref.read(pdfTabsProvider).tabs.length <= 1;
                          if (isLastTab) Navigator.of(context).pop();
                          ref
                              .read(pdfTabsProvider.notifier)
                              .closeTab(tab.url);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.colors.text.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.x,
                            size: 14,
                            color: context.colors.surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(RadiusToken.lg),
                ),
                border: Border(top: BorderSide(color: context.colors.border)),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  if (tab.courseCode?.isNotEmpty ?? false)
                    Text(
                      tab.lessonNo != null
                          ? '${tab.courseCode!.toUpperCase()} : ${tab.lessonNo}'
                          : tab.courseCode!.toUpperCase(),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontSize: FontSizeToken.xxs,
                        fontWeight: .bold,
                        color: active
                            ? context.colors.primary
                            : context.colors.textMuted,
                      ),
                    ),
                  Text(
                    tab.title,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: TextStyle(
                      fontSize: FontSizeToken.xs,
                      fontWeight: active ? .bold : .normal,
                      color: active
                          ? context.colors.primary
                          : context.colors.text,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewFallback(BuildContext context) {
    return Container(
      color: context.colors.surfaceAlt,
      alignment: Alignment.center,
      child: Icon(
        LucideIcons.fileText,
        size: 40,
        color: context.colors.textMuted,
      ),
    );
  }
}
