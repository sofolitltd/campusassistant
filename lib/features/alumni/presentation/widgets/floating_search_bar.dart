import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/alumni_provider.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedOrg = ref.watch(alumniSelectedOrganizationProvider);

    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search name, batch, org...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(
                          LucideIcons.search,
                          size: 14,
                          color: Colors.grey.shade400,
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
                                  horizontal: 10,
                                ),
                                child: Icon(
                                  LucideIcons.circleX,
                                  size: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        maxHeight: 28,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                Container(
                  height: 18,
                  width: 1,
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
                GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.building,
                          size: 14,
                          color: selectedOrg != null
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          selectedOrg != null
                              ? (selectedOrg.name.length > 10
                                    ? '${selectedOrg.name.substring(0, 8)}...'
                                    : selectedOrg.name)
                              : 'Org',
                          style: TextStyle(
                            color: selectedOrg != null
                                ? Theme.of(context).primaryColor
                                : (isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (selectedOrg != null) ...[
                          const SizedBox(width: 4),
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
                              color: Colors.red.shade700,
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
