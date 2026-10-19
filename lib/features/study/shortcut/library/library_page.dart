import 'dart:async';

import '/features/resource/presentation/widgets/resource_card.dart';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/section_tab_bar.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/glass_search_bar.dart';
import '/core/theme/tokens/app_spacing.dart';
import '../../presentation/providers/library_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/study/widgets/filter_picker_sheet.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final isUni = _tabController.index == 1;
        if (ref.read(libraryScopeUniversityProvider) == isUni) return;
        ref.read(libraryScopeUniversityProvider.notifier).state = isUni;
        // Level/course belong to the department in view, which just changed.
        _clearLevelAndCourse();
      }
    });
  }

  void _clearLevelAndCourse() {
    ref.read(librarySelectedLevelProvider.notifier).state = null;
    ref.read(librarySelectedCourseProvider.notifier).state = null;
  }

  void _clearFilters() {
    ref.read(librarySelectedDepartmentProvider.notifier).state = null;
    _clearLevelAndCourse();
  }

  static String _shortDeptName(String name) =>
      name.replaceFirst(RegExp(r'^Department of\s+', caseSensitive: false), '');

  Future<void> _showDepartmentSheet(BuildContext context) async {
    final universityId =
        ref.read(userProvider).value?.information.universityId ?? '';
    final depts = await ref
        .read(libraryDepartmentsProvider(universityId).future)
        .catchError((_) => <({String id, String name})>[]);
    if (!context.mounted) return;
    final selectedId = ref.read(librarySelectedDepartmentProvider);

    showFilterPickerSheet(
      context,
      title: 'Select Department',
      searchHint: 'Search department...',
      allLabel: 'All Departments',
      options: depts.map((d) => _shortDeptName(d.name)).toList(),
      selected: depts
          .where((d) => d.id == selectedId)
          .map((d) => _shortDeptName(d.name))
          .firstOrNull,
      onSelected: (name) {
        final id = depts
            .where((d) => _shortDeptName(d.name) == name)
            .firstOrNull
            ?.id;
        if (id == selectedId) return;
        ref.read(librarySelectedDepartmentProvider.notifier).state = id;
        _clearLevelAndCourse();
      },
    );
  }

  Future<void> _showLevelSheet(
    BuildContext context,
    String departmentId,
  ) async {
    final levels = await ref
        .read(libraryLevelsProvider(departmentId).future)
        .catchError((_) => <({String id, String name})>[]);
    if (!context.mounted) return;
    final selectedId = ref.read(librarySelectedLevelProvider);

    showFilterPickerSheet(
      context,
      title: 'Select Level',
      searchHint: 'Search level...',
      allLabel: 'All Levels',
      options: levels.map((l) => l.name).toList(),
      selected: levels.where((l) => l.id == selectedId).firstOrNull?.name,
      onSelected: (name) async {
        final levelId = levels.where((l) => l.name == name).firstOrNull?.id;
        ref.read(librarySelectedLevelProvider.notifier).state = levelId;
        // Drop a course that isn't in the new level.
        final course = ref.read(librarySelectedCourseProvider);
        if (levelId == null || course == null) return;
        final courses = await ref
            .read(libraryCoursesProvider(departmentId).future)
            .catchError((_) => <({String code, String levelId})>[]);
        if (!courses.any((c) => c.levelId == levelId && c.code == course)) {
          ref.read(librarySelectedCourseProvider.notifier).state = null;
        }
      },
    );
  }

  Future<void> _showCourseSheet(
    BuildContext context,
    String departmentId,
  ) async {
    final levelId = ref.read(librarySelectedLevelProvider);
    final courses = await ref
        .read(libraryCoursesProvider(departmentId).future)
        .catchError((_) => <({String code, String levelId})>[]);
    if (!context.mounted) return;
    final rawCodes = courses
        .where((c) => levelId == null || c.levelId == levelId)
        .map((c) => c.code)
        .toList();
    final options = rawCodes.map((c) => c.toUpperCase()).toSet().toList()
      ..sort();
    final selected = ref.read(librarySelectedCourseProvider);

    showFilterPickerSheet(
      context,
      title: 'Select Course',
      searchHint: 'Search course...',
      allLabel: 'All Courses',
      options: options,
      selected: selected?.toUpperCase(),
      // Pass back the code exactly as stored, so the filter matches it.
      onSelected: (code) =>
          ref.read(librarySelectedCourseProvider.notifier).state = code == null
          ? null
          : rawCodes.firstWhere(
              (c) => c.toUpperCase() == code,
              orElse: () => code,
            ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? context.colors.primary : context.colors.text;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? context.colors.primarySubtle
              : context.colors.surface,
          border: Border.all(
            color: isActive ? context.colors.primary : context.colors.border,
          ),
          borderRadius: BorderRadius.circular(RadiusToken.md),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FontSizeToken.md,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Icon(Icons.keyboard_arrow_down, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    final isUni = ref.watch(libraryScopeUniversityProvider);
    final departmentId = ref.watch(libraryDepartmentIdProvider);
    final selectedDeptId = ref.watch(librarySelectedDepartmentProvider);
    final selectedLevelId = ref.watch(librarySelectedLevelProvider);
    final selectedCourse = ref.watch(librarySelectedCourseProvider);
    final universityId =
        ref.watch(userProvider).value?.information.universityId ?? '';

    final deptName = selectedDeptId == null
        ? null
        : (ref.watch(libraryDepartmentsProvider(universityId)).value ?? [])
              .where((d) => d.id == selectedDeptId)
              .map((d) => _shortDeptName(d.name))
              .firstOrNull;
    final levelName = selectedLevelId == null || departmentId.isEmpty
        ? null
        : (ref.watch(libraryLevelsProvider(departmentId)).value ?? [])
              .where((l) => l.id == selectedLevelId)
              .firstOrNull
              ?.name;
    final hasFilter =
        (isUni && selectedDeptId != null) ||
        selectedLevelId != null ||
        selectedCourse != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.xs,
        Spacing.lg,
        Spacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (isUni) ...[
                    _buildFilterChip(
                      label: deptName ?? 'Department',
                      isActive: selectedDeptId != null,
                      onTap: () => _showDepartmentSheet(context),
                    ),
                    const SizedBox(width: Spacing.sm),
                  ],
                  // Level and course need a single department in view.
                  if (departmentId.isNotEmpty) ...[
                    _buildFilterChip(
                      label: levelName ?? 'Level',
                      isActive: selectedLevelId != null,
                      onTap: () => _showLevelSheet(context, departmentId),
                    ),
                    const SizedBox(width: Spacing.sm),
                    _buildFilterChip(
                      label: selectedCourse?.toUpperCase() ?? 'Course',
                      isActive: selectedCourse != null,
                      onTap: () => _showCourseSheet(context, departmentId),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (hasFilter)
            GestureDetector(
              onTap: _clearFilters,
              behavior: HitTestBehavior.opaque,
              child: Semantics(
                button: true,
                label: 'Clear filters',
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Spacing.sm,
                    top: Spacing.xs,
                    bottom: Spacing.xs,
                  ),
                  child: Icon(
                    LucideIcons.x,
                    size: 18,
                    color: context.colors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(librarySearchQueryProvider.notifier).state = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final libraryAsync = ref.watch(libraryPaginationProvider);

    return CustomHeaderLayout(
      title: 'Academic Library',
      showSearchBar: true,
      searchAtBottom: true,
      searchHint: 'Search by book, author or course...',
      onSearchChanged: _onSearchChanged,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.lg,
              Spacing.lg,
              Spacing.sm,
            ),
            child: SectionTabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Department'),
                Tab(text: 'University'),
              ],
            ),
          ),
          _buildFilterRow(context),
          Expanded(
            child: libraryAsync.when(
              data: (state) {
                if (state.docs.isEmpty && !state.isLoadingMore) {
                  return const Center(child: Text('No books found.'));
                }

                return ListView.separated(
                  // Bottom padding clears the floating search bar.
                  padding: EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.sm,
                    Spacing.lg,
                    GlassSearchBar.listBottomPadding(context),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: Spacing.md),
                  controller: _scrollController,
                  // +1 for the footer: a loader while more pages remain, else
                  // the end-of-list count.
                  itemCount: state.docs.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.docs.length - 5 &&
                        state.hasMore &&
                        !state.isLoadingMore) {
                      Future.microtask(() {
                        ref
                            .read(libraryPaginationProvider.notifier)
                            .loadNextPage();
                      });
                    }

                    if (index < state.docs.length) {
                      final doc = state.docs[index];
                      return ResourceCard(resource: doc);
                    } else if (!state.hasMore) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.sm,
                        ),
                        child: Center(
                          child: Text(
                            '${state.docs.length} loaded',
                            style: TextStyle(
                              fontSize: FontSizeToken.sm,
                              color: context.colors.textMuted,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: Spacing.lg),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CupertinoActivityIndicator(),
                              ),
                              SizedBox(width: Spacing.sm),
                              Text(
                                'Loading more books...',
                                style: TextStyle(fontSize: FontSizeToken.sm),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, st) => Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      LucideIcons.circleAlert,
                      color: context.colors.danger,
                      size: 48,
                    ),
                    const SizedBox(height: Spacing.lg),
                    Text('Error: $e'),
                    TextButton(
                      onPressed: () => ref
                          .read(libraryPaginationProvider.notifier)
                          .refresh(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
