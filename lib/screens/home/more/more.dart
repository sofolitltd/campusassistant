import 'package:campusassistant/screens/home/more/blood/blood.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import '/screens/home/more/clubs/clubs.dart';
import '/screens/home/more/emergency/emergency.dart';
import 'routine/routine.dart';
import 'transport/transport.dart';

class More extends StatelessWidget {
  final ProfileData profileData;

  const More({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      // color: Colors.green,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * .19
            : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // const Headline(title: 'More'),

          //list
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: moreList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
              separatorBuilder: (context, index) => const SizedBox(width: 0),
              itemBuilder: (context, index) => MoreCard(
                index: index,
                profileData: profileData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
class MoreCard extends StatelessWidget {
  final ProfileData profileData;
  final int index;

  const MoreCard({
    super.key,
    required this.index,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Routine(
                          profileData: profileData,
                        )));
            break;
          case 1:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Emergency(profileData: profileData)));
            break;
          case 2:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Transport(profileData: profileData)));
            break;
          case 3:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BloodBank(profileData: profileData)));
          case 4:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Clubs(profileData: profileData)));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          Container(
            height: 56,
            width: 56,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 4,
                    color: Colors.black12.withValues(alpha: .02),
                  ),
                ],
                // borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(moreList[index].imageUrl),
                  fit: BoxFit.cover,
                )),
          ),

          //
          Container(
            width: 88,
            padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Text(
              '${moreList[index].name}'.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    // fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

List moreList = [
  MoreModel(
    name: 'Class\nRoutine',
    route: 'routine',
    imageUrl: 'assets/images/1.png',
    color: 0xff012544,
  ),
  MoreModel(
      name: 'Emergency\nContact',
      route: 'emergency',
      imageUrl: 'assets/images/2.png',
      color: 0xff012544),
  MoreModel(
    name: 'Transport\nService',
    route: 'transports',
    imageUrl: 'assets/images/3.png',
    color: 0xff012544,
  ),
  MoreModel(
    name: 'Blood\nBank',
    route: 'blood',
    imageUrl: 'assets/images/4.png',
    color: 0xff012544,
  ),
  MoreModel(
    name: 'Club&\nOrg.',
    route: 'clubs',
    imageUrl: 'assets/images/5.png',
    color: 0xff012544,
  ),
];

//
class MoreModel {
  final String name;
  final String route;
  final String imageUrl;
  final int color;

  MoreModel({
    required this.name,
    required this.route,
    required this.imageUrl,
    required this.color,
  });
}
