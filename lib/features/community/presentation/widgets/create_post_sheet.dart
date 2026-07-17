import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;

class CreatePostSheet extends ConsumerStatefulWidget {
  final int tabIndex;
  final VoidCallback onPostCreated;

  const CreatePostSheet({
    super.key,
    required this.tabIndex,
    required this.onPostCreated,
  });

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              Text(
                'Create Post',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_controller.text.trim().isEmpty) return;

                  final scopes = ['batch', 'department', 'university', 'saved'];
                  final currentScope = scopes[widget.tabIndex];
                  if (currentScope == 'saved') {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a feed tab to post'),
                      ),
                    );
                    return;
                  }

                  try {
                    await ref
                        .read(communityRepositoryProvider)
                        .createPost(_controller.text.trim(), currentScope);
                    if (context.mounted) {
                      ref.read(communityRefreshProvider.notifier).increment();
                      Navigator.pop(context);
                      widget.onPostCreated();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post published to community!'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to post: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(70, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Post', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.1),
                backgroundImage: ref
                    .watch(currentUserProvider)
                    .maybeWhen(
                      data: (user) => user?.profileImage != null
                          ? NetworkImage(user!.profileImage!)
                          : null,
                      orElse: () => null,
                    ),
                child: ref
                    .watch(currentUserProvider)
                    .maybeWhen(
                      data: (user) => user?.profileImage == null
                          ? Icon(
                              LucideIcons.user,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                      orElse: () => Icon(
                        LucideIcons.user,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref
                        .watch(currentUserProvider)
                        .maybeWhen(
                          data: (user) => user != null
                              ? '${user.firstName} ${user.lastName}'
                              : 'User Name',
                          orElse: () => 'User Name',
                        ),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Posting to Community',
                    style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              autofocus: true,
              style: GoogleFonts.outfit(fontSize: 16),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(LucideIcons.image), onPressed: () {}),
              IconButton(
                icon: const Icon(LucideIcons.paperclip),
                onPressed: () {},
              ),
              IconButton(icon: const Icon(LucideIcons.smile), onPressed: () {}),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
