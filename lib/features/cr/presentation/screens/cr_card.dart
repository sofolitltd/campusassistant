import 'package:cached_network_image/cached_network_image.dart';
import '/features/cr/data/models/cr_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';

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
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 14,
              children: [
                // Image
                Container(
                  height: 95,
                  width: 85,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(RadiusToken.sm),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: cr.imageUrl,
                    fadeInDuration: const Duration(milliseconds: 500),
                    imageBuilder: (_, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                        image: DecorationImage(
                          fit: BoxFit.cover,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name
                      Text(
                        cr.name,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold, height: 1.2),
                      ),

                      const SizedBox(height: 8),

                      // phone + share
                      Row(
                        spacing: 8,
                        children: [
                          _tag(
                            cr.isCurrent ? 'Current' : 'Former',
                            cr.isCurrent
                                ? Colors.teal.shade50
                                : Colors.red.shade50,
                          ),
                          _tag(cr.batch, Colors.grey.shade100),
                        ],
                      ),

                      const SizedBox(height: 10),
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
                            icon: const Icon(
                              LucideIcons.share2,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),

                          // email
                          if (cr.email.isNotEmpty)
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: const CircleBorder(),
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: () async {
                                OpenApp.withEmail(cr.email);
                              },
                              icon: const Icon(
                                LucideIcons.mail,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),

                          //fb
                          if (cr.fb.isNotEmpty)
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: const CircleBorder(),
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: () async {
                                OpenApp.withUrl(cr.fb);
                              },
                              icon: const Icon(
                                LucideIcons.link,
                                color: Colors.white,
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
                              icon: const Icon(
                                LucideIcons.phone,
                                color: Colors.white,
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
    padding: const EdgeInsets.fromLTRB(8, 2, 8, 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: color,
    ),
    child: Text(text, style: const TextStyle(fontSize: 11)),
  );
}
