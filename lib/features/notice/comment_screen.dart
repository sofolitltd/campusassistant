import 'package:flutter/material.dart';

import '/features/auth/domain/entities/user.dart' as user_entity;

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.noticeId, required this.user});

  final String noticeId;
  final user_entity.User user;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comment')),
      body: const Column(
        children: [
          Expanded(
            child: Center(child: Text('Comments are temporarily unavailable.')),
          ),
        ],
      ),
    );
  }
}
