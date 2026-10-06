import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/profile/data/models/profile_model.dart';
import '/features/staff/domain/entities/staff.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

/// A single staff member — drop-in card styled like `TeacherCard`. Tap opens
/// the staff details route (built in, no external onTap wiring needed); call,
/// share and copy live on the details screen.
class StaffCard extends StatelessWidget {
  final Staff staff;
  final ProfileModel? user;

  const StaffCard({super.key, required this.staff, this.user});

  @override
  Widget build(BuildContext context) {
    final showSerial = user?.information.status?.moderator == true;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.lg),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: () => context.push('/staff/details?id=${staff.id}'),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              _StaffImage(imageUrl: staff.imageUrl),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      showSerial
                          ? '${staff.serial}. ${staff.name}'
                          : staff.name,
                      style: const TextStyle(
                        fontWeight: .w700,
                        fontSize: FontSizeToken.base,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      staff.post,
                      style: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: FontSizeToken.sm,
                        fontWeight: .w500,
                      ),
                    ),
                    if (staff.phone.isNotEmpty) ...[
                      const SizedBox(height: Spacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceAlt,
                          borderRadius: BorderRadius.circular(RadiusToken.sm),
                        ),
                        child: Text(
                          staff.phone,
                          style: TextStyle(
                            color: context.colors.textMuted,
                            fontSize: FontSizeToken.xxs,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: Spacing.xs),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: context.colors.textSubtle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffImage extends StatelessWidget {
  final String imageUrl;
  const _StaffImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          image: const DecorationImage(
            image: AssetImage('assets/images/pp_placeholder.png'),
            fit: .cover,
          ),
        ),
      );
    }
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.surfaceAlt),
        borderRadius: BorderRadius.circular(RadiusToken.sm),
      ),
      child: CachedNetworkImage(
        imageUrl: ApiEndpoints.resolveImageUrl(imageUrl),
        fadeInDuration: const Duration(milliseconds: 500),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            image: DecorationImage(image: imageProvider, fit: .cover),
          ),
        ),
        progressIndicatorBuilder: (_, _, _) =>
            const CupertinoActivityIndicator(),
        errorWidget: (_, _, _) => Container(
          decoration: BoxDecoration(
            color: context.colors.primary,
            borderRadius: BorderRadius.circular(RadiusToken.sm),
            image: const DecorationImage(
              image: AssetImage('assets/images/pp_placeholder.png'),
              fit: .cover,
            ),
          ),
        ),
      ),
    );
  }
}
