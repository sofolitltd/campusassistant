import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/widgets/open_app.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/widgets/custom_header_layout.dart';
import '/features/staff/domain/entities/staff.dart';
import '/features/staff/presentation/providers/staff_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class StaffDetailsScreen extends ConsumerWidget {
  const StaffDetailsScreen({super.key, required this.staffId});

  final String staffId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(singleStaffProvider(staffId));

    return CustomHeaderLayout(
      title: 'Staff Profile',
      showSearchBar: false,
      body: staffAsync.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Text(
              error.toString(),
              textAlign: .center,
              style: TextStyle(
                color: context.colors.danger,
                fontSize: FontSizeToken.md,
              ),
            ),
          ),
        ),
        data: (staff) => SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              _HeaderCard(staff: staff),
              const SizedBox(height: Spacing.lg),
              _DetailCard(
                children: [
                  _InfoRow(
                    label: 'Mobile',
                    value: staff.mobile.isNotEmpty ? staff.mobile : '—',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(crossAxisAlignment: .start, children: children),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.staff});

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusToken.md),
                border: Border.all(
                  color: context.colors.surfaceAlt,
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                child: CachedNetworkImage(
                  imageUrl: ApiEndpoints.resolveImageUrl(staff.imageUrl),
                  fit: .cover,
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(radius: 6),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    LucideIcons.user,
                    color: context.colors.borderStrong,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    staff.name,
                    style: const TextStyle(
                      fontWeight: .bold,
                      fontSize: FontSizeToken.lg,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    staff.post,
                    style: TextStyle(
                      color: context.colors.textMuted,
                      fontSize: FontSizeToken.md,
                      fontWeight: .w500,
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
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: .bold,
              fontSize: FontSizeToken.md,
              color: context.colors.textSubtle,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => OpenApp.withNumber(value),
            child: Text(
              value,
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .w600,
                decoration: .underline,
                decorationColor: context.colors.info,
                color: context.colors.info,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
