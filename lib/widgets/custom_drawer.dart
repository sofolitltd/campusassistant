import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/screens/contributor/contributor.dart';
import '/utils/constants.dart';
import '/widgets/open_app.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            //
            Drawer(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(8),
                                color: Colors.pink.shade100,
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/reyad.jpg'))),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            kDeveloperName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          const Text('App Developer | UI/UX Designer'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.orange[100],
                                ),
                                child: const Text(
                                  kDeveloperBatch,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.blue.shade100,
                                ),
                                child: const Text(
                                  kDeveloperSession,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Department of Psychology',
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                          Text(
                            'University of Chittagong',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
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
                                  padding:
                                      const EdgeInsets.all(kIsWeb ? 16 : 8),
                                  child: const Icon(
                                    Icons.call,
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
                                  padding:
                                      const EdgeInsets.all(kIsWeb ? 16 : 8),
                                  child: const Icon(
                                    Icons.mail,
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
                                  padding:
                                      const EdgeInsets.all(kIsWeb ? 16 : 8),
                                  child: const Icon(
                                    Icons.facebook,
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    //
                    ListTileTheme(
                      horizontalTitleGap: 0,
                      minVerticalPadding: 0,
                      dense: true,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(5),
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
                              visualDensity: const VisualDensity(vertical: -2),
                              leading: const Icon(
                                Icons.facebook_outlined,
                                color: Colors.blue,
                              ),
                              title: const Text(
                                'Facebook Page',
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // youtube
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kYoutubeUrl);
                              },
                              visualDensity: const VisualDensity(vertical: -2),
                              leading: const Icon(
                                Icons.video_collection_rounded,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Youtube Channel',
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Rate us
                            ListTile(
                              onTap: () {
                                OpenApp.withUrl(kPlayStoreUrl);
                              },
                              visualDensity: const VisualDensity(vertical: -2),
                              leading: const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              title: const Text(
                                'Rate on PLay Store',
                              ),
                              trailing: const Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 18,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // contributors
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ContributorsScreen()));
                                },
                                child: Text('Our contributors'.toUpperCase()),
                              ),
                            ),

                            const SizedBox(height: 16),
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
                top: 8,
                right: 8,
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear)),
            ),
          ],
        ),
      ),
    );
  }
}

//
