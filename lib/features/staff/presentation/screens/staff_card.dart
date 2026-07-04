import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import 'package:campusassistant/features/profile/data/models/profile_model.dart';
import '/features/staff/domain/entities/staff.dart';
import '/widgets/open_app.dart';

class StaffCard extends StatelessWidget {
  final Staff staff;
  final ProfileModel? user;

  const StaffCard({super.key, required this.staff, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StaffImage(imageUrl: staff.imageUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (user?.information.status?.moderator == true)
                            Text(
                              '${staff.serial}. ',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          Expanded(
                            child: Text(
                              staff.name,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        staff.post,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (staff.phone.isNotEmpty)
                        Text(
                          staff.phone,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
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

                        final url = staff.imageUrl;
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
                    icon: const Icon(
                      LucideIcons.share2,
                      color: Colors.black,
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
                    icon: const Icon(
                      LucideIcons.phone,
                      color: Colors.white,
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
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: AssetImage('assets/images/pp_placeholder.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Container(
      height: 95,
      width: 85,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fadeInDuration: const Duration(milliseconds: 500),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        progressIndicatorBuilder: (_, _, _) =>
            const CupertinoActivityIndicator(),
        errorWidget: (_, _, _) => Container(
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage('assets/images/pp_placeholder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
