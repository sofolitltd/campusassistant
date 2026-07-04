import 'package:cached_network_image/cached_network_image.dart';
import 'package:campusassistant/features/teacher/domain/entities/teacher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/red_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/routes/app_route.dart';
import '/features/teacher/presentation/providers/teacher_provider.dart';
import '/core/theme/tokens/app_radius.dart';

class TeacherPage extends ConsumerStatefulWidget {
  const TeacherPage({super.key});

  @override
  ConsumerState<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends ConsumerState<TeacherPage>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
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
    return RedHeaderLayout(
      title: 'Faculty Members',
      searchHint: 'Search by name, dept or designation...',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SectionTabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Present'),
                Tab(text: 'Leave'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TeacherListView(isPresent: true, searchQuery: _searchQuery),
                TeacherListView(isPresent: false, searchQuery: _searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherListView extends ConsumerWidget {
  const TeacherListView({
    super.key,
    required this.isPresent,
    required this.searchQuery,
  });

  final bool isPresent;
  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersAsync = ref.watch(teachersListProvider(isPresent));

    return teachersAsync.when(
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent, fontSize: 13),
          ),
        ),
      ),
      data: (teachers) {
        // Filter teachers by search query
        final filteredTeachers = teachers.where((t) {
          final query = searchQuery.toLowerCase();
          return t.name.toLowerCase().contains(query) ||
              t.post.toLowerCase().contains(query);
        }).toList();

        if (filteredTeachers.isEmpty) {
          return _buildEmpty(isPresent, searchQuery.isNotEmpty);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          physics: const BouncingScrollPhysics(),
          itemCount: filteredTeachers.length,
          itemBuilder: (context, index) {
            final teacher = filteredTeachers[index];
            return _TeacherCard(teacher: teacher);
          },
        );
      },
    );
  }

  Widget _buildEmpty(bool isPresent, bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? LucideIcons.searchX : LucideIcons.userX,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            isSearching
                ? 'No matches found'
                : 'No ${isPresent ? "present" : "on leave"} faculties',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final Teacher teacher;

  const _TeacherCard({required this.teacher});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        onTap: () =>
            context.push('${AppRoute.teacher.path}/details?id=${teacher.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(isDark),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teacher.post,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (teacher.phd.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white10
                              : Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          teacher.phd,
                          style: TextStyle(
                            color: isDark
                                ? Colors.blue.shade300
                                : Colors.blueGrey.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    return Stack(
      clipBehavior: Clip.none,
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
              placeholder: (context, url) =>
                  const Center(child: CupertinoActivityIndicator(radius: 6)),
              errorWidget: (context, url, error) => Icon(
                LucideIcons.user,
                color: Colors.grey.shade300,
                size: 24,
              ),
            ),
          ),
        ),
        if (teacher.chairman)
          Positioned(
            bottom: -2,
            left: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF008080), Color(0xFF006666)],
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Text(
                'CHAIRMAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
