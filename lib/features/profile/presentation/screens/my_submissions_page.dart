import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/resource/presentation/providers/resource_provider.dart';
import '/features/study/widgets/content_card.dart';
import '/features/study/data/models/content_model.dart';
import '/core/theme/tokens/app_spacing.dart';

class MySubmissionsPage extends ConsumerWidget {
  const MySubmissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;

    if (user == null) {
      if (userAsync.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return const Scaffold(
        body: Center(child: Text('Please login to see your submissions')),
      );
    }

    final ResourceParams params = (
      universityId: user.information.universityId ?? '',
      departmentId: user.information.departmentId ?? '',
      type: null,
      courseCode: null,
      batch: null,
      batchId: null,
      lessonNo: null,
      uploaderUid: user.uid,
      status: null,
    );

    final submissionsAsync = ref.watch(resourcesListProvider(
      universityId: params.universityId,
      departmentId: params.departmentId,
      type: params.type,
      courseCode: params.courseCode,
      batch: params.batch,
      batchId: params.batchId,
      lessonNo: params.lessonNo,
      uploaderUid: params.uploaderUid,
      status: params.status,
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('My Submissions'), centerTitle: true),
      body: submissionsAsync.when(
        data: (resources) {
          if (resources.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.cloudUpload,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    'No submissions yet',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Resources you upload will appear here',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: resources.length,
            separatorBuilder: (context, index) => const SizedBox(height: Spacing.lg),
            itemBuilder: (context, index) {
              final resource = resources[index];

              // Map to ContentModel for ContentCard
              final contentModel = ContentModel(
                contentId: resource.id,
                courseCode: resource.courseCode,
                contentType: resource.type,
                lessonNo: resource.lessonNo,
                status: resource.status,
                batches: resource.batches,
                contentTitle: resource.title,
                contentSubtitle: resource.description,
                contentSubtitleType: resource.courseTitle,
                uploadDate: (resource.createdAt ?? DateTime.now())
                    .toString()
                    .split(' ')[0],
                fileUrl: resource.fileUrl,
                imageUrl: resource.thumbnailUrl,
                uploader: resource.uploaderName,
                departmentId: resource.departmentId,
                metadata: {
                  ...resource.metadata,
                  'fileSizeBytes': resource.fileSizeBytes,
                  'pageCount': resource.pageCount,
                  'downloadCount': resource.downloadCount,
                  'viewCount': resource.viewCount,
                  'ratingAvg': resource.ratingAvg,
                  'tags': resource.tags,
                },
              );

              return ContentCard(
                contentModel: contentModel,
                // For simplicity, we might not allow editing from here yet
                // but we could in the future.
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
