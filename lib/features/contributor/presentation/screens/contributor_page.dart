import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/models/contributor_model.dart';
import '../providers/contributor_provider.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/custom_header_layout.dart';

class ContributorPage extends ConsumerWidget {
  const ContributorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributorsAsync = ref.watch(contributorsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomHeaderLayout(
      title: 'Our Contributors',
      showSearchBar: false,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(contributorsProvider);
          await ref.read(contributorsProvider.future);
        },
        child: contributorsAsync.when(
          data: (contributors) {
            if (contributors.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.users,
                            size: 64,
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No contributors yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: contributors.length,
              itemBuilder: (context, index) {
                return _ContributorCard(contributor: contributors[index]);
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, _) => Center(
            child: Text(
              'Failed to load contributors',
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContributorCard extends StatelessWidget {
  final ContributorModel contributor;

  const _ContributorCard({required this.contributor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showContributorDetails(context, contributor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _ContributorAvatar(contributor: contributor, radius: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contributor.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _TierBadge(tier: contributor.tier),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: isDark ? Colors.white30 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContributorAvatar extends StatelessWidget {
  final ContributorModel contributor;
  final double radius;

  const _ContributorAvatar({required this.contributor, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (contributor.imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).appColors.primaryColor,
        child: Text(
          _getInitials(contributor.name),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.55,
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).appColors.primaryColor,
      backgroundImage: NetworkImage(
        ApiEndpoints.resolveImageUrl(contributor.imageUrl),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class _TierBadge extends StatelessWidget {
  final String tier;

  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    if (tier.isEmpty) return const SizedBox.shrink();
    final color = _tierColor(tier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: Text(
        tier,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Color _tierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return const Color(0xFF6366F1);
      case 'gold':
        return const Color(0xFFF59E0B);
      case 'silver':
        return const Color(0xFF64748B);
      case 'bronze':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF00897B);
    }
  }
}

void _showContributorDetails(BuildContext context, ContributorModel c) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ContributorAvatar(contributor: c, radius: 44),
              const SizedBox(height: 16),
              Text(
                c.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _TierBadge(tier: c.tier),
              const SizedBox(height: 20),
              _DetailRow(label: 'University', value: c.universityName),
              _DetailRow(label: 'Department', value: c.departmentName),
              _DetailRow(label: 'Session', value: c.session),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white38 : Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
