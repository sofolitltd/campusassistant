import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/teacher/presentation/providers/teacher_provider.dart';
import '/features/teacher/presentation/widgets/teacher_card.dart';

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
    return CustomHeaderLayout(
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
            return TeacherCard(teacher: teacher);
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
