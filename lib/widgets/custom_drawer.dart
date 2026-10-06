import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/utils/constants.dart';
import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.sm,
          0,
          Spacing.sm,
          Spacing.sm,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            //
            Drawer(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
              ),

              //from right side
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  // mainAxisAlignment: .spaceBetween,
                  children: [
                    //
                    Padding(
                      padding: const EdgeInsets.all(Spacing.lg),
                      child: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .max,
                        children: [
                          const SizedBox(height: Spacing.sm),
                          Text(
                            'Developer:',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(fontWeight: .bold),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.all(Spacing.sm),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(RadiusToken.sm),
                              color: context.colors.primarySubtle,
                              image: const DecorationImage(
                                fit: .cover,
                                image: AssetImage('assets/images/reyad.jpg'),
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Text(
                            kDeveloperName,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: .bold),
                          ),
                          // const SizedBox(height: Spacing.xs),
                          Text(
                            'App Developer | UI/UX Designer',

                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(),
                          ),
                          const SizedBox(height: Spacing.md),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.xs,
                                  ),
                                  color: context.colors.warningSubtle,
                                ),
                                child: Text(
                                  kDeveloperBatch,
                                  style: TextStyle(
                                    fontSize: FontSizeToken.sm,
                                    fontWeight: .w500,
                                    color: context.colors.text,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.xs,
                                  ),
                                  color: context.colors.infoSubtle,
                                ),
                                child: Text(
                                  kDeveloperSession,
                                  style: TextStyle(
                                    fontSize: FontSizeToken.sm,
                                    fontWeight: .w500,
                                    color: context.colors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            'Department of Psychology',
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                          Text(
                            'University of Chittagong',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(fontWeight: .bold),
                          ),

                          const SizedBox(height: Spacing.md),

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              context.push('/developer');
                            },
                            child: Container(
                              width: 154,
                              decoration: BoxDecoration(
                                color: context.colors.shadow,
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.md,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                                vertical: Spacing.sm,
                              ),
                              child: Row(
                                spacing: 8,
                                children: [
                                  Text(
                                    "Contact Developer",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          height: 1,
                                          fontWeight: .bold,
                                          color: context.colors.primary,
                                        ),
                                  ),
                                  Icon(
                                    LucideIcons.arrowUpRight,
                                    size: 14,
                                    color: context.colors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.sm),

                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            'Follow us',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(fontWeight: .bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.sm),

                    //
                    ListTileTheme(
                      horizontalTitleGap: 10,
                      minVerticalPadding: 0,
                      dense: true,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: context.colors.border,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.lg,
                        ),
                        child: Column(
                          children: [
                            // fb
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kFbGroup);
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                              ),
                              leading: Icon(
                                LucideIcons.link,
                                color: context.colors.info,
                              ),
                              title: const Text('Facebook Page'),
                              trailing: const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                              ),
                            ),

                            const SizedBox(height: Spacing.sm),

                            // youtube
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kYoutubeUrl);
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                              ),
                              leading: Icon(
                                LucideIcons.link,
                                color: context.colors.danger,
                              ),
                              title: const Text('Youtube Channel'),
                              trailing: const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                              ),
                            ),

                            const SizedBox(height: Spacing.sm),

                            // Rate us
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kPlayStoreUrl);
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                              ),
                              leading: Icon(
                                LucideIcons.star,
                                color: context.colors.warning,
                              ),
                              title: const Text('Rate on PlayStore'),
                              trailing: const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                              ),
                            ),

                            const SizedBox(height: Spacing.sm),

                            // Send Feedback
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                context.push(AppRoute.feedback.path);
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                              ),
                              leading: Icon(
                                LucideIcons.messageSquare,
                                color: context.colors.primary,
                              ),
                              title: const Text('Send Feedback'),
                              trailing: const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                              ),
                            ),

                            const SizedBox(height: Spacing.xxl),

                            // contributors
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.push('/contributors');
                                },
                                child: const Text('Our contributors'),
                              ),
                            ),

                            const SizedBox(height: Spacing.lg),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.sm,
                right: Spacing.sm,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(LucideIcons.x),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
