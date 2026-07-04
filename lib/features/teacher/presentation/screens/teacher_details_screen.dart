import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import '/widgets/open_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' hide Share;

import '/features/teacher/domain/entities/teacher.dart';
import '/features/teacher/presentation/providers/teacher_provider.dart';

class TeacherDetailsScreen extends ConsumerStatefulWidget {
  const TeacherDetailsScreen({super.key, required this.teacherId});

  final String teacherId;

  @override
  ConsumerState<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends ConsumerState<TeacherDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacherAsync = ref.watch(singleTeacherProvider(widget.teacherId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return teacherAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (teacherModel) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Faculty Profile'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () async => _shareProfile(teacherModel),
              ),
            ],
          ),
          body: Column(
            children: [
              // Fixed Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: _HeaderCard(teacher: teacherModel),
              ),
              
              // Custom Tabs
              _buildSmoothTabControl(isDark),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _ContactTab(teacher: teacherModel),
                    _AcademicTab(teacher: teacherModel),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareProfile(Teacher teacherModel) async {
    try {
      final url = teacherModel.imageUrl;
      final dio = Dio();
      final response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      final bytes = response.data;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${teacherModel.name}.png');
      await file.writeAsBytes(bytes);

      final text = "${teacherModel.name}\n${teacherModel.post}\n${teacherModel.phd}\n\n"
          "Mobile: ${teacherModel.mobile}\nEmail: ${teacherModel.email}\n\n"
          "Publications: ${teacherModel.publications}\n\n"
          "Interests: ${teacherModel.interests}";

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: text,
        ),
      );
    } catch (e) {
      debugPrint('Error sharing profile: $e');
    }
  }

  Widget _buildSmoothTabControl(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmoothTab('Contact', 0, isDark),
                  const SizedBox(width: 4),
                  _buildSmoothTab('Academic', 1, isDark),
                ],
              );
            },
          ),
        ),
      ),
    );
  }




  Widget _buildSmoothTab(String label, int index, bool isDark) {
    final double animationValue = _tabController.animation!.value;
    final double distance = (index - animationValue).abs();
    final double progress = (1.0 - distance).clamp(0.0, 1.0);

    final Color activeColor = isDark ? Colors.white : Colors.black;
    final Color inactiveColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
    final Color activeTextColor = isDark ? Colors.black : Colors.white;
    final Color inactiveTextColor = Colors.grey.shade600;

    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 32,
        decoration: BoxDecoration(
          color: Color.lerp(inactiveColor, activeColor, progress),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color.lerp(
              isDark ? Colors.white24 : Colors.grey.shade300,
              isDark ? Colors.white24 : Colors.grey.shade300,
              progress,
            )!,
            width: 1,
          ),
          boxShadow: progress > 0.5
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.1 * progress),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Color.lerp(inactiveTextColor, activeTextColor, progress),
              fontWeight: progress > 0.5 ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }


}

class _ContactTab extends StatelessWidget {
  final Teacher teacher;
  const _ContactTab({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Mobile', value: teacher.mobile.isNotEmpty ? teacher.mobile : '—'),
              const Divider(height: 24),
              _InfoRow(label: 'Email', value: teacher.email.isNotEmpty ? teacher.email : '—'),
            ],
          ),
        ),
      ),
    );
  }
}

class _AcademicTab extends StatelessWidget {
  final Teacher teacher;
  const _AcademicTab({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _AcademicSection(
            title: 'Publications',
            content: teacher.publications.isNotEmpty ? teacher.publications : 'No publications available.',
            isLink: teacher.publications.isNotEmpty,
          ),
          const SizedBox(height: 16),
          _AcademicSection(
            title: 'Research Interests',
            isInterests: true,
            interests: teacher.interests,
            content: '',
          ),
        ],
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          if (isInterests)
            interests.isEmpty 
              ? const Text('No research interests listed.', style: TextStyle(color: Colors.grey, fontSize: 13))
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interests.split(',').map((interest) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(interest.trim(), style: TextStyle(color: Colors.blueGrey.shade800, fontSize: 11, fontWeight: FontWeight.w600)),
                  )).toList(),
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
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
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
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: teacher.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Image.asset('assets/images/pp_placeholder.png', fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(teacher.post, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
                  if (teacher.phd.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(teacher.phd, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ),
                  if (teacher.chairman)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(4)),
                      child: const Text('CHAIRMAN', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
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
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (value.contains('@')) {
                OpenApp.withEmail(value);
              } else {
                OpenApp.withNumber(value);
              }
            },
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, decoration: TextDecoration.underline, decorationColor: Colors.blue, color: Colors.blue)),
          ),
        ),
      ],
    );
  }
}

