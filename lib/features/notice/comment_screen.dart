import 'package:material_ui/material_ui.dart';

import '/features/auth/domain/entities/user.dart' as user_entity;
import '/core/widgets/header_gradient_backdrop.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';

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
    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Comment',
            style: TextStyle(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.colors.onPrimary),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(RadiusToken.xxxl),
                  ),
                ),
                child: const Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text('Comments are temporarily unavailable.'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
