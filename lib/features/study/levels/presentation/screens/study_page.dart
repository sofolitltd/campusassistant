import '/routes/scaffold_with_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '../providers/semester_provider.dart';
import '/core/theme/app_colors.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/bookmark/presentation/providers/bookmark_provider.dart';
import '/core/providers/download_counter_provider.dart';
import '/features/study/widgets/batch_dropdown.dart';
import '/features/study/widgets/resource_shortcuts_bar.dart';
import '../../domain/entities/semester.dart';
import '../widgets/semester_grid_card.dart';
import '../widgets/semester_list_card.dart';

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});

  @override
  ConsumerState<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage>
    with SingleTickerProviderStateMixin {
  bool isGridView = false;
  bool _sortAscending = false;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final currentBatch = ref.watch(resolvedBatchProvider);
    final batchesAsync = ref.watch(batchProviderStudy);
    final semesters = ref.watch(filteredSemestersProvider);

    var displaySemesters = List.from(semesters)
      ..sort(
        (a, b) => _sortAscending
            ? a.order.compareTo(b.order)
            : b.order.compareTo(a.order),
      );

    final bookmarksAsync = ref.watch(
      userBookmarksProvider(userAsync.value?.uid ?? ''),
    );
    final bookmarkCount = bookmarksAsync.when(
      data: (list) => list.length,
      loading: () => 0,
      error: (_, _) => 0,
    );

    final downloadsAsync = ref.watch(downloadCountProvider);
    final downloadCount = downloadsAsync.when(
      data: (count) => count,
      loading: () => 0,
      error: (_, _) => 0,
    );

    final theme = Theme.of(context);
    final primaryColor = Theme.of(context).appColors.primaryColor;

    final isLoading =
        batchesAsync.isLoading ||
        currentBatch == null ||
        ref.watch(semestersProvider).isLoading;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Study',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () =>
                  ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(semestersProvider);
                  ref.invalidate(batchProviderStudy);
                  await ref.read(semestersProvider.future);
                },
                child: isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          // Resources horizontal list
                          SliverToBoxAdapter(
                            child: ResourceShortcutsBar(
                              bookmarkCount: bookmarkCount,
                              downloadCount: downloadCount,
                            ),
                          ),

                      // Levels header row
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => isGridView = false),
                                    child: Icon(
                                      Icons.list_alt,
                                      color: !isGridView
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.onSurface
                                              .withAlpha(100),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => isGridView = true),
                                    child: Icon(
                                      Icons.grid_view_outlined,
                                      color: isGridView
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.onSurface
                                              .withAlpha(100),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(
                                      () => _sortAscending = !_sortAscending,
                                    ),
                                    child: Icon(
                                      _sortAscending
                                          ? LucideIcons.arrowUpWideNarrow
                                          : LucideIcons.arrowDownWideNarrow,
                                      size: 20,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const BatchDropdown(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Semesters content
                      if (displaySemesters.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.frown,
                                  size: 48,
                                  color: theme.colorScheme.onSurface
                                      .withAlpha(100),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No semesters found.",
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(128),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (isGridView)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          sliver: SliverMasonryGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childCount: displaySemesters.length,
                            itemBuilder: (context, index) {
                              final semester = displaySemesters[index];
                              return GestureDetector(
                                onTap: () => _goToSemester(semester),
                                child: SemesterGridCard(semester: semester),
                              );
                            },
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final semester = displaySemesters[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
                                    onTap: () => _goToSemester(semester),
                                    child: SemesterListCard(
                                      semester: semester,
                                    ),
                                  ),
                                );
                              },
                              childCount: displaySemesters.length,
                            ),
                          ),
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

  void _goToSemester(Semester semester) {
    final batch = ref.read(resolvedBatchProvider);
    final batchParam = batch != null
        ? (batch.slug.isNotEmpty ? batch.slug : batch.id)
        : null;
    final uri = Uri(
      path: '/study/courses',
      queryParameters: {
        'batch': batchParam,
        'semesterName': semester.name,
        'semesterId': semester.id,
      },
    );
    context.push(uri.toString());
  }
}

