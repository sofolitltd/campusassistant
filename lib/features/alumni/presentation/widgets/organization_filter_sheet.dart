import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/alumni_provider.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_font_size.dart';

Future<void> showOrganizationFilterSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: context.colors.surfaceInverse.withValues(alpha: 0.5),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return _OrgFilterSheetBody(scrollController: scrollController);
        },
      );
    },
  );
}

class _OrgFilterSheetBody extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const _OrgFilterSheetBody({required this.scrollController});

  @override
  ConsumerState<_OrgFilterSheetBody> createState() =>
      _OrgFilterSheetBodyState();
}

class _OrgFilterSheetBodyState extends ConsumerState<_OrgFilterSheetBody> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final orgsAsync = ref.watch(
      alumniOrganizationsProvider(search: _searchQuery),
    );
    final selectedOrg = ref.watch(alumniSelectedOrganizationProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxxl),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: Spacing.md),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: context.colors.borderStrong,
              borderRadius: BorderRadius.circular(RadiusToken.md),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Select Organization',
                  style: TextStyle(
                    fontSize: FontSizeToken.xl,
                    fontWeight: .bold,
                    color: context.colors.text,
                  ),
                ),
                Row(
                  mainAxisSize: .min,
                  children: [
                    if (selectedOrg != null)
                      TextButton(
                        onPressed: () {
                          ref
                              .read(alumniSelectedOrganizationProvider.notifier)
                              .update(null);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Clear Filter',
                          style: TextStyle(
                            fontWeight: .w600,
                            color: context.colors.danger,
                          ),
                        ),
                      ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.close_rounded,
                        color: context.colors.textMuted,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
                borderRadius: BorderRadius.circular(RadiusToken.lg),
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: TextStyle(color: context.colors.text),
                decoration: InputDecoration(
                  hintText: 'Search organizations...',
                  hintStyle: TextStyle(
                    color: context.colors.textSubtle,
                    fontSize: FontSizeToken.lg,
                  ),
                  prefixIcon: Icon(
                    LucideIcons.search,
                    color: context.colors.textSubtle,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.lg,
                    vertical: Spacing.lg,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Expanded(
            child: orgsAsync.when(
              data: (orgs) {
                if (orgs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.xxxl),
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            Icons.business_rounded,
                            size: 48,
                            color: context.colors.borderStrong,
                          ),
                          const SizedBox(height: Spacing.md),
                          Text(
                            'No organizations found',
                            style: TextStyle(
                              fontSize: FontSizeToken.base,
                              fontWeight: .w600,
                              color: context.colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  itemCount: orgs.length,
                  itemBuilder: (context, index) {
                    final org = orgs[index];
                    final isSelected = selectedOrg?.id == org.id;

                    final h = (org.name.hashCode.abs() % 360).toDouble();
                    final orgColor = HSLColor.fromAHSL(
                      1.0,
                      h,
                      0.55,
                      0.45,
                    ).toColor();

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: orgColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            org.name.isNotEmpty
                                ? org.name[0].toUpperCase()
                                : 'O',
                            style: TextStyle(
                              color: orgColor,
                              fontWeight: .bold,
                              fontSize: FontSizeToken.lg,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        org.name,
                        style: TextStyle(
                          fontSize: FontSizeToken.lg,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? primaryColor
                              : (context.colors.text),
                        ),
                      ),
                      subtitle: org.website.isNotEmpty
                          ? Text(
                              org.website,
                              style: TextStyle(
                                fontSize: FontSizeToken.sm,
                                color: context.colors.textSubtle,
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: primaryColor,
                            )
                          : null,
                      onTap: () {
                        ref
                            .read(alumniSelectedOrganizationProvider.notifier)
                            .update(org);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) => Center(
                child: Text(
                  'Error: $err',
                  style: TextStyle(color: context.colors.danger),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
