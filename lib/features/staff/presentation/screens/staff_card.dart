import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/features/profile/data/models/profile_model.dart';
import '/features/staff/domain/entities/staff.dart';
import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class StaffCard extends StatelessWidget {
  final Staff staff;
  final ProfileModel? user;

  const StaffCard({super.key, required this.staff, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        boxShadow: [
          BoxShadow(
            color: context.colors.textSubtle.withValues(alpha: 0.05),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
                _StaffImage(imageUrl: staff.imageUrl),
                const SizedBox(width: Spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          if (user?.information.status?.moderator == true)
                            Text(
                              '${staff.serial}. ',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: .bold),
                            ),
                          Expanded(
                            child: Text(
                              staff.name,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: .bold, height: 1.2),
                              maxLines: 1,
                              overflow: .ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        staff.post,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: .w600,
                          color: context.colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      if (staff.phone.isNotEmpty)
                        Text(
                          staff.phone,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontWeight: .bold,
                                fontSize: FontSizeToken.base,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Row(
                spacing: 4,
                children: [
                  // Share Button
                  IconButton.filledTonal(
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(shape: const CircleBorder()),
                    onPressed: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sharing profile...'),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        final url = ApiEndpoints.resolveImageUrl(
                          staff.imageUrl,
                        );
                        final response = await Dio().get(
                          url,
                          options: Options(responseType: ResponseType.bytes),
                        );
                        final bytes = response.data;

                        final tempDir = await getTemporaryDirectory();
                        final file = File('${tempDir.path}/${staff.name}.png');
                        await file.writeAsBytes(bytes);

                        final text =
                            '${staff.name}\n${staff.post}\n\nPhone:\n+88${staff.phone}';

                        await SharePlus.instance.share(
                          ShareParams(
                            files: [XFile(file.path)],
                            title: 'Profile of ${staff.name}',
                            text: text,
                          ),
                        );
                      } catch (e) {
                        debugPrint('Error sharing profile: $e');
                      }
                    },
                    icon: Icon(
                      LucideIcons.share2,
                      color: context.colors.text,
                      size: 16,
                    ),
                  ),

                  // Call Button
                  IconButton.filled(
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(shape: const CircleBorder()),
                    onPressed: () async {
                      OpenApp.withNumber(staff.phone);
                    },
                    icon: Icon(
                      LucideIcons.phone,
                      color: context.colors.onPrimary,
                      size: 16,
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

class _StaffImage extends StatelessWidget {
  final String imageUrl;
  const _StaffImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 95,
        width: 85,
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(RadiusToken.sm),
          image: const DecorationImage(
            image: AssetImage('assets/images/pp_placeholder.png'),
            fit: .cover,
          ),
        ),
      );
    }
    return Container(
      height: 95,
      width: 85,
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
