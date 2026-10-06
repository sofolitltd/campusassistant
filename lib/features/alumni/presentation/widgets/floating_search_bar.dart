import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/alumni_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class FloatingSearchBar extends ConsumerStatefulWidget {
  final VoidCallback onFilterTap;

  const FloatingSearchBar({super.key, required this.onFilterTap});

  @override
  ConsumerState<FloatingSearchBar> createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends ConsumerState<FloatingSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrg = ref.watch(alumniSelectedOrganizationProvider);

    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusToken.xxl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(RadiusToken.xxl),
              border: Border.all(color: context.colors.borderStrong, width: 1),
              boxShadow: [
                BoxShadow(
                  color: context.colors.shadow,
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        ref
                            .read(alumniSearchQueryProvider.notifier)
                            .update(val);
                      });
                    },
                    style: TextStyle(
                      fontSize: FontSizeToken.md,
                      color: context.colors.text,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search name, batch, org...',
                      hintStyle: TextStyle(
                        color: context.colors.textSubtle,
                        fontSize: FontSizeToken.sm,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                          left: Spacing.md,
                          right: Spacing.sm,
                        ),
                        child: Icon(
                          LucideIcons.search,
                          size: 14,
                          color: context.colors.textSubtle,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 32),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                ref
                                    .read(alumniSearchQueryProvider.notifier)
                                    .update('');
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                ),
                                child: Icon(
                                  LucideIcons.circleX,
                                  size: 14,
                                  color: context.colors.textSubtle,
                                ),
                              ),
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        maxHeight: 28,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: Spacing.md,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 18,
                  width: 1,
                  color: context.colors.borderStrong,
                ),
                GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          LucideIcons.building,
                          size: 14,
                          color: selectedOrg != null
                              ? Theme.of(context).primaryColor
                              : context.colors.textSubtle,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          selectedOrg != null
                              ? (selectedOrg.name.length > 10
                                    ? '${selectedOrg.name.substring(0, 8)}...'
                                    : selectedOrg.name)
                              : 'Org',
                          style: TextStyle(
                            color: selectedOrg != null
                                ? Theme.of(context).primaryColor
                                : (context.colors.textMuted),
                            fontSize: FontSizeToken.sm,
                            fontWeight: .bold,
                          ),
                        ),
                        if (selectedOrg != null) ...[
                          const SizedBox(width: Spacing.xs),
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(
                                    alumniSelectedOrganizationProvider.notifier,
                                  )
                                  .update(null);
                            },
                            child: Icon(
                              LucideIcons.circleX,
                              size: 12,
                              color: context.colors.danger,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
