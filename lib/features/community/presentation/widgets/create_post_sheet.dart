import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;
import '/features/community/utils/image_compress.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

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
  final List<Uint8List> _images = [];
  bool _isUploading = false;

  static const int _maxImages = 4;
  static const int _maxTotalBytes =
      1 * 1024 * 1024; // 1 MB total after compression

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

  Future<void> _pickImages() async {
    if (_images.length >= _maxImages) return;
    final picked = await ImagePicker().pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 80,
    );
    if (picked.isEmpty) return;

    for (final xfile in picked) {
      if (_images.length >= _maxImages) break;
      final compressed = await compressCommunityImage(File(xfile.path));
      if (!mounted) return;
      if (compressed.lengthInBytes > _maxTotalBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('One image is too large even after compression.'),
          ),
        );
        continue;
      }
      if (totalImageBytes([..._images, compressed]) > _maxTotalBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Total image size must stay under 1 MB.'),
          ),
        );
        break;
      }
      setState(() => _images.add(compressed));
    }
  }

  void _removeImage(int index) => setState(() => _images.removeAt(index));

  @override
  Widget build(BuildContext context) {
    final scopeLabels = ['Batch', 'Department', 'My University'];
    final currentLabel = scopeLabels[widget.tabIndex];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxl),
        ),
      ),
      padding: const EdgeInsets.all(Spacing.xl),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              Text(
                'Create Post',
                style: GoogleFonts.outfit(
                  fontWeight: .bold,
                  fontSize: FontSizeToken.lg,
                ),
              ),
              ElevatedButton(
                onPressed: _isUploading
                    ? null
                    : () async {
                        if (_controller.text.trim().isEmpty &&
                            _images.isEmpty) {
                          return;
                        }

                        final scopes = ['batch', 'department', 'university'];
                        final currentScope = scopes[widget.tabIndex];

                        setState(() => _isUploading = true);
                        try {
                          await ref
                              .read(communityRepositoryProvider)
                              .createPost(
                                _controller.text.trim(),
                                currentScope,
                                images: _images,
                              );
                          if (context.mounted) {
                            ref
                                .read(communityRefreshProvider.notifier)
                                .increment();
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
                        } finally {
                          if (mounted) setState(() => _isUploading = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(70, ControlToken.height),
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                ),
                child: _isUploading
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CupertinoActivityIndicator(
                          color: context.colors.onPrimary,
                        ),
                      )
                    : const Text(
                        'Post',
                        style: TextStyle(fontSize: FontSizeToken.md),
                      ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: Spacing.md),
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
                          ? NetworkImage(
                              ApiEndpoints.resolveImageUrl(user!.profileImage),
                            )
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
              const SizedBox(width: Spacing.md),
              Column(
                crossAxisAlignment: .start,
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
                      fontWeight: .w600,
                      fontSize: FontSizeToken.base,
                    ),
                  ),
                  Text(
                    'Post to $currentLabel',
                    style: GoogleFonts.outfit(
                      fontSize: FontSizeToken.sm,
                      color: context.colors.textSubtle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Spacing.xl),
          if (_images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _images.length; i++)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(RadiusToken.md),
                          child: Image.memory(
                            _images[i],
                            width: 72,
                            height: 72,
                            fit: .cover,
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: () => _removeImage(i),
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.colors.textMuted,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(Spacing.xxs),
                              child: Icon(
                                LucideIcons.x,
                                size: 14,
                                color: context.colors.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              autofocus: true,
              style: GoogleFonts.outfit(fontSize: FontSizeToken.lg),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: GoogleFonts.outfit(color: context.colors.textSubtle),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.image),
                onPressed: _images.length >= _maxImages ? null : _pickImages,
                tooltip: _images.length >= _maxImages
                    ? 'Max $_maxImages images'
                    : null,
              ),
              Text(
                '${_images.length}/$_maxImages',
                style: GoogleFonts.outfit(
                  fontSize: FontSizeToken.sm,
                  color: context.colors.textSubtle,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
