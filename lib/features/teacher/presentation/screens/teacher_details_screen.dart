import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import '/widgets/open_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/features/teacher/domain/entities/teacher.dart';
import '/features/teacher/presentation/providers/teacher_provider.dart';
import '/core/widgets/red_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';

class TeacherDetailsScreen extends ConsumerStatefulWidget {
  const TeacherDetailsScreen({super.key, required this.teacherId});

  final String teacherId;

  @override
  ConsumerState<TeacherDetailsScreen> createState() =>
      _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends ConsumerState<TeacherDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final teacherAsync = ref.watch(singleTeacherProvider(widget.teacherId));

    return RedHeaderLayout(
      title: 'Faculty Profile',
      actionIcon: LucideIcons.share2,
      onActionTap: () async {
        final teacherModel = teacherAsync.asData?.value;
        if (teacherModel != null) _shareProfile(teacherModel);
      },
      showSearchBar: false,
      body: teacherAsync.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        ),
        data: (teacherModel) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _HeaderCard(teacher: teacherModel),
              const SizedBox(height: 16),
              _DetailCard(
                children: [
                  _InfoRow(
                    label: 'Mobile',
                    value: teacherModel.mobile.isNotEmpty
                        ? teacherModel.mobile
                        : '—',
                  ),
                  const Divider(height: 24),
                  _InfoRow(
                    label: 'Email',
                    value: teacherModel.email.isNotEmpty
                        ? teacherModel.email
                        : '—',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _AcademicSection(
                title: 'Publications',
                content: teacherModel.publications.isNotEmpty
                    ? teacherModel.publications
                    : 'No publications available.',
                isLink: teacherModel.publications.isNotEmpty,
              ),
              const SizedBox(height: 16),
              _AcademicSection(
                title: 'Research Interests',
                isInterests: true,
                interests: teacherModel.interests,
                content: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareProfile(Teacher teacherModel) async {
    try {
      final url = teacherModel.imageUrl;
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${teacherModel.name}.png');
      await file.writeAsBytes(bytes);

      final text =
          "${teacherModel.name}\n${teacherModel.post}\n${teacherModel.phd}\n\n"
          "Mobile: ${teacherModel.mobile}\nEmail: ${teacherModel.email}\n\n"
          "Publications: ${teacherModel.publications}\n\n"
          "Interests: ${teacherModel.interests}";

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: text),
      );
    } catch (e) {
      debugPrint('Error sharing profile: $e');
    }
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _AcademicSection extends StatelessWidget {
  final String title;
  final String content;
  final bool isLink;
  final bool isInterests;
  final String interests;

  const _AcademicSection({
    required this.title,
    required this.content,
    this.isLink = false,
    this.isInterests = false,
    this.interests = '',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          if (isInterests)
            interests.isEmpty
                ? const Text(
                    'No research interests listed.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests
                        .split(',')
                        .map(
                          (interest) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              interest.trim(),
                              style: TextStyle(
                                color: Colors.blueGrey.shade800,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
          else
            GestureDetector(
              onTap: isLink ? () => OpenApp.withUrl(content) : null,
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: isLink ? Colors.blue : Colors.grey.shade700,
                  decoration: isLink ? TextDecoration.underline : null,
                  decorationColor: isLink ? Colors.blue : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                child: CachedNetworkImage(
                  imageUrl: teacher.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(radius: 6),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    LucideIcons.user,
                    color: Colors.grey.shade300,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacher.post,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (teacher.phd.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        teacher.phd,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  if (teacher.chairman)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'CHAIRMAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (value.contains('@')) {
                OpenApp.withEmail(value);
              } else {
                OpenApp.withNumber(value);
              }
            },
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
