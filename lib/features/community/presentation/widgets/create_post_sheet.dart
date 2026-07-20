import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/features/auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;
import '/features/community/utils/image_compress.dart';

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
  static const int _maxTotalBytes = 1 * 1024 * 1024; // 1 MB total after compression

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scopeLabels = ['Batch', 'Department', 'My University'];
    final currentLabel = scopeLabels[widget.tabIndex];

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
                onPressed: _isUploading
                    ? null
                    : () async {
                        if (_controller.text.trim().isEmpty && _images.isEmpty) {
                          return;
                        }

                        final scopes = [
                          'batch',
                          'department',
                          'university',
                        ];
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
                  minimumSize: const Size(70, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Post', style: TextStyle(fontSize: 13)),
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
                    'Post to $currentLabel',
                    style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _images.length; i++)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _images[i],
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -6,
                          right: -6,
                          child: GestureDetector(
                            onTap: () => _removeImage(i),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                LucideIcons.x,
                                size: 14,
                                color: Colors.white,
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
              IconButton(
                icon: const Icon(LucideIcons.image),
                onPressed: _images.length >= _maxImages ? null : _pickImages,
                tooltip:
                    _images.length >= _maxImages ? 'Max $_maxImages images' : null,
              ),
              Text(
                '${_images.length}/$_maxImages',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey,
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
