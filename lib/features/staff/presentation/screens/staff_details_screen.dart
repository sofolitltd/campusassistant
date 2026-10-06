import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

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
              _ActionBar(staff: staff),
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

/// Call / Share / Copy actions for a staff member.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.staff});

  final Staff staff;

  Future<void> _share(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Sharing profile...'),
          duration: Duration(seconds: 1),
        ),
      );

      final text = '${staff.name}\n${staff.post}\n\nPhone:\n+88${staff.phone}';
      final files = <XFile>[];
      if (staff.imageUrl.isNotEmpty) {
        final response = await Dio().get(
          ApiEndpoints.resolveImageUrl(staff.imageUrl),
          options: Options(responseType: ResponseType.bytes),
        );
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/${staff.name}.png');
        await file.writeAsBytes(response.data);
        files.add(XFile(file.path));
      }

      await SharePlus.instance.share(
        ShareParams(
          files: files,
          title: 'Profile of ${staff.name}',
          text: text,
        ),
      );
    } catch (e) {
      debugPrint('Error sharing profile: $e');
    }
  }

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: staff.phone));
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Phone number copied'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhone = staff.phone.isNotEmpty;

    return Row(
      spacing: Spacing.md,
      children: [
        Expanded(
          child: _ActionButton(
            icon: LucideIcons.phone,
            label: 'Call',
            filled: true,
            onTap: hasPhone ? () => OpenApp.withNumber(staff.phone) : null,
          ),
        ),
        Expanded(
          child: _ActionButton(
            icon: LucideIcons.share2,
            label: 'Share',
            onTap: () => _share(context),
          ),
        ),
        Expanded(
          child: _ActionButton(
            icon: LucideIcons.copy,
            label: 'Copy',
            onTap: hasPhone ? () => _copy(context) : null,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onTap != null;
    final fg = filled ? colors.onPrimary : colors.text;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: filled ? colors.primary : colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(RadiusToken.md),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Spacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusToken.md),
              border: Border.all(
                color: filled ? colors.primary : colors.border,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, size: 18, color: filled ? fg : colors.primary),
                const SizedBox(height: Spacing.xs),
                Text(
                  label,
                  style: TextStyle(
                    color: fg,
                    fontSize: FontSizeToken.sm,
                    fontWeight: .w600,
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
    final colors = context.colors;
    final hasValue = value != '—';

    return InkWell(
      borderRadius: BorderRadius.circular(RadiusToken.sm),
      onTap: hasValue ? () => OpenApp.withNumber(value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.primarySubtle,
                borderRadius: BorderRadius.circular(RadiusToken.sm),
              ),
              child: Icon(
                LucideIcons.smartphone,
                size: 22,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: .w600,
                      fontSize: FontSizeToken.md,
                      color: colors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: FontSizeToken.xl,
                      fontWeight: .w700,
                      color: hasValue ? colors.text : colors.textSubtle,
                    ),
                  ),
                ],
              ),
            ),
            if (hasValue)
              Icon(LucideIcons.phone, size: 20, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
