import 'package:flutter/material.dart';

import 'package:campusassistant/features/auth/domain/entities/user.dart'
    as user_entity;
import 'package:campusassistant/core/theme/tokens/app_spacing.dart';

class NoticeGroup extends StatelessWidget {
  final user_entity.User user;

  const NoticeGroup({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.fullName}\'s Notices'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: Spacing.lg),
            Text(
              'Notices are temporarily unavailable.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'We are migrating to a new backend system.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
