import 'package:cached_network_image/cached_network_image.dart';
import '/features/cr/data/models/cr_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class CrCard extends StatelessWidget {
  const CrCard({super.key, required this.cr});

  final CrModel cr;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.md,
          horizontal: Spacing.md,
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: .start,
              spacing: 14,
              children: [
                // Image
                Container(
                  height: 95,
                  width: 85,
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colors.surfaceAlt),
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: ApiEndpoints.resolveImageUrl(cr.imageUrl),
                    fadeInDuration: const Duration(milliseconds: 500),
                    imageBuilder: (_, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                        image: DecorationImage(
                          fit: .cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                    placeholder: (_, _) => const CupertinoActivityIndicator(),
                    errorWidget: (_, _, _) => const Icon(LucideIcons.user),
                  ),
                ),
                // Left Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      // name
                      Text(
                        cr.name,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: .bold, height: 1.2),
                      ),

                      const SizedBox(height: Spacing.sm),

                      // phone + share
                      Row(
                        spacing: 8,
                        children: [
                          _tag(
                            cr.isCurrent ? 'Current' : 'Former',
                            cr.isCurrent
                                ? context.colors.primary
                                : context.colors.danger,
                          ),
                          _tag(cr.batch, context.colors.surfaceAlt),
                        ],
                      ),

                      const SizedBox(height: Spacing.md),
                      //
                      Row(
                        spacing: 4,
                        children: [
                          // share
                          IconButton.filledTonal(
                            visualDensity: VisualDensity.compact,
                            style: IconButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            onPressed: () async {
                              final text =
                                  '${cr.name}\n${cr.fb}\nPhone: +88${cr.phone}';
                              await SharePlus.instance.share(
                                ShareParams(title: cr.name, text: text),
                              );
                            },
                            icon: Icon(
                              LucideIcons.share2,
                              color: context.colors.text,
                              size: 16,
                            ),
                          ),

                          // email
                          if (cr.email.isNotEmpty)
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: context.colors.danger,
                                shape: const CircleBorder(),
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: () async {
                                OpenApp.withEmail(cr.email);
                              },
                              icon: Icon(
                                LucideIcons.mail,
                                color: context.colors.onPrimary,
                                size: 16,
                              ),
                            ),

                          //fb
                          if (cr.fb.isNotEmpty)
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: context.colors.info,
                                shape: const CircleBorder(),
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: () async {
                                OpenApp.withUrl(cr.fb);
                              },
                              icon: Icon(
                                LucideIcons.link,
                                color: context.colors.onPrimary,
                                size: 16,
                              ),
                            ),

                          //ph
                          if (cr.phone.isNotEmpty)
                            IconButton.filled(
                              visualDensity: VisualDensity.compact,
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                              ),
                              onPressed: () async {
                                OpenApp.withNumber(cr.phone);
                              },
                              icon: Icon(
                                LucideIcons.phone,
                                color: context.colors.onPrimary,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color? color) => Container(
    padding: const EdgeInsets.fromLTRB(
      Spacing.sm,
      Spacing.xxs,
      Spacing.sm,
      Spacing.xs,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(RadiusToken.xs),
      color: color,
    ),
    child: Text(text, style: const TextStyle(fontSize: FontSizeToken.xs)),
  );
}
