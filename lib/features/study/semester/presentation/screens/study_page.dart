import '/routes/app_route.dart';
import '/routes/scaffold_with_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/section_tab_bar.dart';

import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '../providers/semester_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/bookmark/presentation/providers/bookmark_provider.dart';
import '/core/providers/download_counter_provider.dart';
import '/features/study/semester/domain/entities/semester.dart';
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
  final _searchController = TextEditingController();
  final _batchSearchController = TextEditingController();
  String _filterText = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _batchSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final currentBatch = ref.watch(resolvedBatchProvider);
    final batchesAsync = ref.watch(batchProviderStudy);
    final semesters = ref.watch(filteredSemestersProvider);

    final displaySemesters = _filterText.isEmpty
        ? semesters
        : semesters
              .where(
                (s) => s.name.toLowerCase().contains(_filterText.toLowerCase()),
              )
              .toList();

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
    final isDark = theme.brightness == Brightness.dark;
    final primaryRed = const Color(0xFFD32F2F);

    final isLoading =
        batchesAsync.isLoading ||
        currentBatch == null ||
        ref.watch(semestersProvider).isLoading;

    return Scaffold(
      backgroundColor: primaryRed,
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
              onTap: () => ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withAlpha(25) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade400,
                    fontSize: 15,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      LucideIcons.search,
                      size: 20,
                      color: isDark ? Colors.white54 : Colors.grey.shade400,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  suffixIcon: _filterText.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _filterText = '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              LucideIcons.circleX,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(maxHeight: 32),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (v) => setState(() => _filterText = v),
              ),
            ),
          ),

          // White rounded body container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Custom TabBar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: SectionTabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Semesters/Years'),
                        Tab(text: 'Resources'),
                      ],
                    ),
                  ),

                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Semesters View
                        RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(semestersProvider);
                            ref.invalidate(batchProviderStudy);
                            await ref.read(semestersProvider.future);
                          },
                          child: isLoading
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : CustomScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          8,
                                          16,
                                          16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => setState(
                                                    () => isGridView = false,
                                                  ),
                                                  child: Icon(
                                                    Icons.list_alt,
                                                    color: !isGridView
                                                        ? theme
                                                              .colorScheme
                                                              .onSurface
                                                        : theme
                                                              .colorScheme
                                                              .onSurface
                                                              .withAlpha(100),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                GestureDetector(
                                                  onTap: () => setState(
                                                    () => isGridView = true,
                                                  ),
                                                  child: Icon(
                                                    Icons.grid_view_outlined,
                                                    color: isGridView
                                                        ? theme
                                                              .colorScheme
                                                              .onSurface
                                                        : theme
                                                              .colorScheme
                                                              .onSurface
                                                              .withAlpha(100),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _BatchDropdown(
                                              batchesAsync: batchesAsync,
                                              currentBatch: currentBatch,
                                              theme: theme,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (displaySemesters.isEmpty)
                                      SliverToBoxAdapter(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 60,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                LucideIcons.frown,
                                                size: 48,
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withAlpha(100),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                "No semesters found.",
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(128),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else if (isGridView)
                                      SliverPadding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          16,
                                        ),
                                        sliver: SliverMasonryGrid.count(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childCount: displaySemesters.length,
                                          itemBuilder: (context, index) {
                                            final semester =
                                                displaySemesters[index];
                                            return GestureDetector(
                                              onTap: () =>
                                                  _goToSemester(semester),
                                              child: SemesterGridCard(
                                                semester: semester,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    else
                                      SliverPadding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          16,
                                        ),
                                        sliver: SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              final semester =
                                                  displaySemesters[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _goToSemester(semester),
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

                        // Resources View
                        CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 1.5,
                                    ),
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final shortcut = allShortcuts[index];
                                  final isBookmark =
                                      shortcut.imageUrl == 'bookmark';
                                  final isDownload =
                                      shortcut.imageUrl == 'download';
                                  int count = 0;
                                  if (isBookmark) count = bookmarkCount;
                                  if (isDownload) count = downloadCount;

                                  return GestureDetector(
                                    onTap: () {
                                      if (shortcut.isNamedRoute) {
                                        context.pushNamed(shortcut.route);
                                      } else {
                                        context.push(shortcut.route);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isDark
                                              ? Colors.white10
                                              : Colors.grey.shade200,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(8),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: shortcut.color,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      shortcut.icon,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  if (count > 0)
                                                    Positioned(
                                                      right: -4,
                                                      top: -4,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                color: theme
                                                                    .cardColor,
                                                                width: 2,
                                                              ),
                                                            ),
                                                        constraints:
                                                            const BoxConstraints(
                                                              minWidth: 20,
                                                              minHeight: 20,
                                                            ),
                                                        child: Text(
                                                          count.toString(),
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              Icon(
                                                LucideIcons.chevronRight,
                                                size: 16,
                                                color: isDark
                                                    ? Colors.white54
                                                    : Colors.grey.shade400,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            shortcut.name.replaceAll('\n', ' '),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }, childCount: allShortcuts.length),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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

class ShortcutData {
  final String name;
  final String route;
  final bool isNamedRoute;
  final IconData icon;
  final Color color;
  final String? imageUrl; // Used as identifier for badge logic

  ShortcutData({
    required this.name,
    required this.route,
    required this.icon,
    required this.color,
    this.imageUrl,
    this.isNamedRoute = false,
  });
}

final List<ShortcutData> allShortcuts = [
  ShortcutData(
    name: 'Saved Bookmarks',
    route: AppRoute.bookmarks.name,
    isNamedRoute: true,
    icon: LucideIcons.bookmark,
    color: Colors.redAccent,
    imageUrl: 'bookmark',
  ),
  ShortcutData(
    name: 'Download Files',
    route: AppRoute.downloadedFiles.name,
    isNamedRoute: true,
    icon: LucideIcons.folderDown,
    color: Colors.orangeAccent,
    imageUrl: 'download',
  ),
  ShortcutData(
    name: 'Academic Library',
    route: '/library',
    icon: LucideIcons.library,
    color: Colors.blueAccent,
  ),
  ShortcutData(
    name: 'Question Bank',
    route: '/questions',
    icon: LucideIcons.helpCircle,
    color: Colors.purpleAccent,
  ),
  ShortcutData(
    name: 'Full Syllabus',
    route: '/syllabus',
    icon: LucideIcons.fileText,
    color: Colors.pinkAccent,
  ),
  ShortcutData(
    name: 'Research Archive',
    route: '/research',
    icon: LucideIcons.search,
    color: Colors.red.shade400,
  ),
];

class _BatchDropdown extends ConsumerWidget {
  final AsyncValue<List<Batch>> batchesAsync;
  final Batch? currentBatch;
  final ThemeData theme;

  const _BatchDropdown({
    required this.batchesAsync,
    required this.currentBatch,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return batchesAsync.when(
      data: (batches) {
        if (batches.isEmpty) return const SizedBox();
        final batch = currentBatch;

        return GestureDetector(
          onTap: () => _showBatchBottomSheet(context, ref, batches, batch),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.brightness == Brightness.dark
                    ? Colors.white24
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  batch?.name ?? 'All Batches',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        width: 100,
        height: 32,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, __) => const SizedBox(),
    );
  }

  void _showBatchBottomSheet(
    BuildContext context,
    WidgetRef ref,
    List<Batch> batches,
    Batch? currentBatch,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredBatches = searchText.isEmpty
                ? batches
                : batches
                      .where(
                        (b) => b.name.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ),
                      )
                      .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Batch',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            LucideIcons.x,
                            size: 20,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => searchText = v),
                        decoration: InputDecoration(
                          hintText: 'Search batch...',
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            LucideIcons.search,
                            size: 18,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        if (searchText.isEmpty)
                          _BatchTile(
                            title: 'All Batches',
                            isSelected: currentBatch == null,
                            onTap: () {
                              ref
                                  .read(selectedBatchNotifierProvider.notifier)
                                  .setAll();
                              Navigator.pop(context);
                            },
                          ),
                        ...filteredBatches.map(
                          (b) => _BatchTile(
                            title: b.name,
                            isSelected: currentBatch?.id == b.id,
                            onTap: () {
                              ref
                                  .read(selectedBatchNotifierProvider.notifier)
                                  .setSelectedBatch(b);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BatchTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _BatchTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? Colors.red.shade900.withAlpha(50)
                    : const Color(0xFFFDE8E8))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isSelected
                    ? (isDark ? Colors.red.shade300 : Colors.red.shade700)
                    : (isDark ? Colors.white : Colors.black87),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                LucideIcons.check,
                color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
