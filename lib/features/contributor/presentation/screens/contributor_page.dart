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
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_accents.dart';

class ContributorPage extends ConsumerWidget {
  const ContributorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributorsAsync = ref.watch(contributorsProvider);

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
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            LucideIcons.users,
                            size: 64,
                            color: context.colors.borderStrong,
                          ),
                          const SizedBox(height: Spacing.lg),
                          Text(
                            'No contributors yet',
                            style: TextStyle(
                              fontSize: FontSizeToken.xl,
                              fontWeight: .w500,
                              color: context.colors.textSubtle,
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
              padding: const EdgeInsets.all(Spacing.lg),
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
              style: TextStyle(color: context.colors.textSubtle),
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
    return GestureDetector(
      onTap: () => _showContributorDetails(context, contributor),
      child: Container(
        margin: const EdgeInsets.only(bottom: Spacing.md),
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _ContributorAvatar(contributor: contributor, radius: 24),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    contributor.name,
                    style: TextStyle(
                      fontWeight: .w600,
                      fontSize: FontSizeToken.base,
                      color: context.colors.text,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  const SizedBox(height: Spacing.xs),
                  _TierBadge(tier: contributor.tier),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: context.colors.textSubtle,
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
        backgroundColor: context.colors.primary,
        child: Text(
          _getInitials(contributor.name),
          style: TextStyle(
            color: context.colors.onPrimary,
            fontWeight: .bold,
            fontSize: radius * 0.55,
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.primary,
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
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: Text(
        tier,
        style: TextStyle(
          fontSize: FontSizeToken.xs,
          fontWeight: .w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Color _tierColor(String tier) {
    return switch (tier.toLowerCase()) {
      'platinum' => AccentToken.indigo,
      'gold' => AccentToken.amber,
      'silver' => const Color(0xFF64748B),
      'bronze' => const Color(0xFFB45309),
      _ => const Color(0xFF00897B),
    };
  }
}

void _showContributorDetails(BuildContext context, ContributorModel c) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusToken.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: Column(
            mainAxisSize: .min,
            children: [
              _ContributorAvatar(contributor: c, radius: 44),
              const SizedBox(height: Spacing.lg),
              Text(
                c.name,
                textAlign: .center,
                style: TextStyle(
                  fontSize: FontSizeToken.xl,
                  fontWeight: .w700,
                  color: context.colors.text,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              _TierBadge(tier: c.tier),
              const SizedBox(height: Spacing.xl),
              _DetailRow(label: 'University', value: c.universityName),
              _DetailRow(label: 'Department', value: c.departmentName),
              _DetailRow(label: 'Session', value: c.session),
              const SizedBox(height: Spacing.sm),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizeToken.sm,
              fontWeight: .w500,
              color: context.colors.textSubtle,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: .right,
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .w600,
                color: context.colors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
