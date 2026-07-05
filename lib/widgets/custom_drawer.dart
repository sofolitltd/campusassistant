import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/utils/constants.dart';
import '/widgets/open_app.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Developer:'.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(RadiusToken.sm),
                              color: Colors.pink.shade100,
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/reyad.jpg'),
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Text(
                            kDeveloperName,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          // const SizedBox(height: 4),
                          Text(
                            'App Developer | UI/UX Designer',

                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.orange[100],
                                ),
                                child: const Text(
                                  kDeveloperBatch,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.blue.shade100,
                                ),
                                child: const Text(
                                  kDeveloperSession,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Department of Psychology',
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                          Text(
                            'University of Chittagong',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //call
                                MaterialButton(
                                  onPressed: () {
                                    OpenApp.withNumber(kDeveloperMobile);
                                  },
                                  minWidth: 32,
                                  elevation: 2,
                                  color: Colors.green,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(
                                    kIsWeb ? 16 : 8,
                                  ),
                                  child: const Icon(
                                    LucideIcons.phone,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),

                                //mail
                                MaterialButton(
                                  onPressed: () {
                                    OpenApp.withEmail(kAppEmail);
                                  },
                                  minWidth: 32,
                                  elevation: 2,
                                  color: Colors.red,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(
                                    kIsWeb ? 16 : 8,
                                  ),
                                  child: const Icon(
                                    LucideIcons.mail,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),

                                //facebook
                                MaterialButton(
                                  onPressed: () {
                                    OpenApp.withUrl(kDeveloperFb);
                                  },
                                  minWidth: 32,
                                  elevation: 2,
                                  color: Colors.blue,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(
                                    kIsWeb ? 16 : 8,
                                  ),
                                  child: const Icon(
                                    LucideIcons.link,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Follow Us'.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    //
                    ListTileTheme(
                      horizontalTitleGap: 10,
                      minVerticalPadding: 0,
                      dense: true,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // fb
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kFbGroup);
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: const Icon(
                                LucideIcons.link,
                                color: Colors.blue,
                              ),
                              title: const Text('Facebook Page'),
                              trailing: const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // youtube
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kYoutubeUrl);
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: const Icon(
                                LucideIcons.link,
                                color: Colors.red,
                              ),
                              title: const Text('Youtube Channel'),
                              trailing: const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Rate us
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kPlayStoreUrl);
                              },
                              visualDensity: VisualDensity.compact,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              leading: const Icon(
                                LucideIcons.star,
                                color: Colors.orange,
                              ),
                              title: const Text('Rate on PlayStore'),
                              trailing: const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // contributors
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.push('/contributors');
                                },
                                child: const Text('Our Contributors'),
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
              padding: const EdgeInsets.only(top: 8, right: 8),
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
