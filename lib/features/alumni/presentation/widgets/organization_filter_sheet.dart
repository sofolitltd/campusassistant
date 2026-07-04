import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/alumni_provider.dart';
import 'package:campusassistant/core/theme/tokens/app_radius.dart';
import 'package:campusassistant/core/theme/tokens/app_spacing.dart';

Future<void> showOrganizationFilterSheet(
  BuildContext context,
  WidgetRef ref,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  String sheetSearchQuery = '';

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setSheetState) {
              final primaryColor = Theme.of(context).primaryColor;
              final orgsAsync = ref.watch(
                alumniOrganizationsProvider(search: sheetSearchQuery),
              );
              final selectedOrg = ref.watch(
                alumniSelectedOrganizationProvider,
              );

              return Container(
                decoration: BoxDecoration(
                  color: isDark ? Theme.of(context).cardColor : Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Organization',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : Colors.grey.shade900,
                            ),
                          ),
                          if (selectedOrg != null)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(
                                      alumniSelectedOrganizationProvider
                                          .notifier,
                                    )
                                    .update(null);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Clear Filter',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setSheetState(() {
                              sheetSearchQuery = val;
                            });
                          },
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search organizations...',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade500,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
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
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.business_rounded,
                                      size: 48,
                                      color: isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No organizations found',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: orgs.length,
                            itemBuilder: (context, index) {
                              final org = orgs[index];
                              final isSelected = selectedOrg?.id == org.id;

                              final h = (org.name.hashCode.abs() % 360)
                                  .toDouble();
                              final orgColor = HSLColor.fromAHSL(
                                1.0, h, 0.55, 0.45,
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  org.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? primaryColor
                                        : (isDark
                                              ? Colors.white70
                                              : Colors.grey.shade800),
                                  ),
                                ),
                                subtitle: org.website.isNotEmpty
                                    ? Text(
                                        org.website,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey.shade500
                                              : Colors.grey.shade500,
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
                                      .read(
                                        alumniSelectedOrganizationProvider
                                            .notifier,
                                      )
                                      .update(org);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(
                          child: Text(
                            'Error: $err',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
