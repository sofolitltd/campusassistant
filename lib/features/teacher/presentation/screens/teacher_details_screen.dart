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
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

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

    return CustomHeaderLayout(
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
            padding: const EdgeInsets.all(Spacing.xl),
            child: Text(
              error.toString(),
              textAlign: .center,
              style: TextStyle(
                color: context.colors.danger,
                fontSize: FontSizeToken.md,
              ),
            ),
          ),
        ),
        data: (teacherModel) => SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              _HeaderCard(teacher: teacherModel),
              const SizedBox(height: Spacing.lg),
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
              const SizedBox(height: Spacing.lg),
              _AcademicSection(
                title: 'Publications',
                content: teacherModel.publications.isNotEmpty
                    ? teacherModel.publications
                    : 'No publications available.',
                isLink: teacherModel.publications.isNotEmpty,
              ),
              const SizedBox(height: Spacing.lg),
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
      final text =
          "${teacherModel.name}\n${teacherModel.post}\n${teacherModel.phd}\n\n"
          "Mobile: ${teacherModel.mobile}\nEmail: ${teacherModel.email}\n\n"
          "Publications: ${teacherModel.publications}\n\n"
          "Interests: ${teacherModel.interests}";

      XFile? imageFile;
      final url = ApiEndpoints.resolveImageUrl(teacherModel.imageUrl);
      if (url.isNotEmpty) {
        final dio = Dio();
        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/${teacherModel.name}.png');
        await file.writeAsBytes(response.data);
        imageFile = XFile(file.path);
      }

      await SharePlus.instance.share(
        ShareParams(files: imageFile != null ? [imageFile] : null, text: text),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(crossAxisAlignment: .start, children: children),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: .bold,
              fontSize: FontSizeToken.base,
            ),
          ),
          const SizedBox(height: Spacing.md),
          if (isInterests)
            interests.isEmpty
                ? Text(
                    'No research interests listed.',
                    style: TextStyle(
                      color: context.colors.textSubtle,
                      fontSize: FontSizeToken.md,
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests
                        .split(',')
                        .map(
                          (interest) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.md,
                              vertical: Spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceAlt,
                              borderRadius: BorderRadius.circular(
                                RadiusToken.sm,
                              ),
                            ),
                            child: Text(
                              interest.trim(),
                              style: TextStyle(
                                color: context.colors.text,
                                fontSize: FontSizeToken.xs,
                                fontWeight: .w600,
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
                  fontSize: FontSizeToken.md,
                  color: isLink
                      ? context.colors.info
                      : context.colors.textMuted,
                  decoration: isLink ? TextDecoration.underline : null,
                  decorationColor: isLink ? context.colors.info : null,
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusToken.md),
                border: Border.all(
                  color: context.colors.surfaceAlt,
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                child: CachedNetworkImage(
                  imageUrl: ApiEndpoints.resolveImageUrl(teacher.imageUrl),
                  fit: .cover,
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(radius: 6),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    LucideIcons.user,
                    color: context.colors.borderStrong,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    teacher.name,
                    style: const TextStyle(
                      fontWeight: .bold,
                      fontSize: FontSizeToken.lg,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    teacher.post,
                    style: TextStyle(
                      color: context.colors.textMuted,
                      fontSize: FontSizeToken.md,
                      fontWeight: .w500,
                    ),
                  ),
                  if (teacher.phd.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.xs),
                      child: Text(
                        teacher.phd,
                        style: TextStyle(
                          fontSize: FontSizeToken.xs,
                          color: context.colors.textSubtle,
                        ),
                      ),
                    ),
                  if (teacher.chairman)
                    Container(
                      margin: const EdgeInsets.only(top: Spacing.sm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        borderRadius: BorderRadius.circular(RadiusToken.xs),
                      ),
                      child: Text(
                        'CHAIRMAN',
                        style: TextStyle(
                          color: context.colors.onPrimary,
                          fontSize: FontSizeToken.xxs,
                          fontWeight: .bold,
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
      crossAxisAlignment: .start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: .bold,
              fontSize: FontSizeToken.md,
              color: context.colors.textSubtle,
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
              style: TextStyle(
                fontSize: FontSizeToken.md,
                fontWeight: .w600,
                decoration: .underline,
                decorationColor: context.colors.info,
                color: context.colors.info,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
