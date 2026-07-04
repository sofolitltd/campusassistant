import '/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/selected_batch_provider.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '../providers/semester_provider.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/widgets/headline.dart';
import '/features/bookmark/presentation/providers/bookmark_provider.dart';
import '/core/providers/download_counter_provider.dart';
import '../widgets/semester_grid_card.dart';
import '../widgets/semester_list_card.dart';

class StudyPage extends ConsumerStatefulWidget {
  const StudyPage({super.key});

  @override
  ConsumerState<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {
  bool isGridView = false;
  final _searchController = TextEditingController();
  String _filterText = '';

  @override
  void dispose() {
    _searchController.dispose();
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

    final isLoading = batchesAsync.isLoading ||
        currentBatch == null ||
        ref.watch(semestersProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
        actions: const [SizedBox(width: 16)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(semestersProvider);
          ref.invalidate(batchProviderStudy);
          await ref.read(semestersProvider.future);
        },
        child: Skeletonizer(
        enabled: isLoading,
        child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Horizontal shortcut list
            Container(
              height: 124,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.separated(
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                physics: const BouncingScrollPhysics(),
                itemCount: shortcutList1.length,
                itemBuilder: (context, index) {
                  final shortcut = shortcutList1[index];

                  return GestureDetector(
                    onTap: () => context.push(shortcut.route),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 2,
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.grey.shade50,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(shortcut.imageUrl),
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
                            child: Text(
                              shortcut.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                height: 1.2,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            //
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: shortcutList2.map((shortcut) {
                  final bool isBookmark = shortcut.imageUrl == 'bookmark';
                  final int count = isBookmark ? bookmarkCount : downloadCount;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => context.pushNamed(shortcut.route),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            // Icon Container with Badge
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : (isBookmark
                                              ? Colors.teal.shade50
                                              : Colors.red.shade50),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isBookmark
                                        ? LucideIcons.bookmark
                                        : LucideIcons.folderDown,
                                    size: 20,
                                    color: isDark
                                        ? (isBookmark
                                              ? Colors.teal.shade200
                                              : Colors.red.shade200)
                                        : null,
                                  ),
                                ),
                                // Badge
                                if (count > 0)
                                  Positioned(
                                    right: -4,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: isBookmark
                                            ? Colors.teal
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.cardColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        count.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // Text Label
                            Expanded(
                              child: Text(
                                shortcut.name,
                                style: theme.textTheme.bodySmall!.copyWith(
                                  height: 1.3,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 16),
            // Title + toggle buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 16, 4),
              child: Row(
                children: [
                  const Expanded(child: Headline(title: 'Semesters/Years')),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.list_alt,
                          color: !isGridView
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                        ),
                        onPressed: () => setState(() => isGridView = false),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.grid_view_outlined,
                          color: isGridView
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                        ),
                        onPressed: () => setState(() => isGridView = true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Filter + batch dropdown
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _filterText = v),
                        decoration: InputDecoration(
                          hintText: 'Search ...',
                          suffixIcon: _filterText.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() => _filterText = '');
                                  },
                                  child: const Icon(Icons.close, size: 18),
                                )
                              : null,
                          isDense: true,
                          contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                        
                          ),
                          
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _BatchDropdown(
                    batchesAsync: batchesAsync,
                    currentBatch: currentBatch,
                    theme: theme,
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),
            // Semesters List / Grid
            if (displaySemesters.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.frown,
                        size: 48,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No semesters found for this batch.",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (isGridView)
              MasonryGridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: displaySemesters.length,
                itemBuilder: (context, index) {
                  final semester = displaySemesters[index];
                  return GestureDetector(
                    onTap: () {
                      final batch = ref.read(resolvedBatchProvider);
                      final batchParam = batch != null
                          ? (batch.slug.isNotEmpty ? batch.slug : batch.id)
                          : null;
                      final uri = Uri(
                        path: '/study/courses',
                        queryParameters: {
                          'batch': ?batchParam,
                          'semesterName': semester.name,
                          'semesterId': semester.id,
                        },
                      );
                      context.push(uri.toString());
                    },
                    child: SemesterGridCard(semester: semester),
                  );
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemCount: displaySemesters.length,
                itemBuilder: (context, index) {
                  final semester = displaySemesters[index];
                  return GestureDetector(
                    onTap: () {
                      final batch = ref.read(resolvedBatchProvider);
                      final batchParam = batch != null
                          ? (batch.slug.isNotEmpty ? batch.slug : batch.id)
                          : null;
                      final uri = Uri(
                        path: '/study/courses',
                        queryParameters: {
                          'batch': ?batchParam,
                          'semesterName': semester.name,
                          'semesterId': semester.id,
                        },
                      );
                      context.push(uri.toString());
                    },
                    child: SemesterListCard(semester: semester),
                  );
                },
              ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}

List<MoreModel> shortcutList1 = [
  MoreModel(
    name: 'Academic\nLibrary',
    route: '/library',
    imageUrl: 'assets/images/shortcut/library.png',
  ),
  MoreModel(
    name: 'Question\nBank',
    route: '/questions',
    imageUrl: 'assets/images/shortcut/questions.png',
  ),
  MoreModel(
    name: 'Full\nSyllabus',
    route: '/syllabus',
    imageUrl: 'assets/images/shortcut/syllabus.png',
  ),
  MoreModel(
    name: 'Research\nArchive',
    route: '/research',
    imageUrl: 'assets/images/shortcut/research.png',
  ),
];

List<MoreModel> shortcutList2 = [
  MoreModel(
    name: 'Saved\nBookmarks',
    route: AppRoute.bookmarks.name,
    imageUrl: 'bookmark',
  ),
  MoreModel(
    name: 'Download\nFiles',
    route: AppRoute.downloadedFiles.name,
    imageUrl: 'download',
  ),
];

class MoreModel {
  final String name;
  final String route;
  final String imageUrl;

  MoreModel({required this.name, required this.route, required this.imageUrl});
}

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
        if (batches.isEmpty) return const Text("No batches");
        final batch = currentBatch;

        return SizedBox(
          height: 36,
          child: Stack(
            children: [
              const Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 16),
              ),
              DropdownMenu<String?>(
                width: 110,
                initialSelection: batch?.id,
                hintText: 'Select Batch',
                textStyle: const TextStyle(fontSize: 14),
                requestFocusOnTap: false,
                showTrailingIcon: false,
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  constraints: const BoxConstraints.tightFor(height: 36),
                  isDense: true,
                  isCollapsed: true,
                ),
                alignmentOffset: const Offset(0, 8),
                onSelected: (id) {
                  if (id == 'all_batches') {
                    ref.read(selectedBatchNotifierProvider.notifier).setAll();
                  } else if (id != null) {
                    final batchObj = batches
                        .where((b) => b.id == id)
                        .firstOrNull;
                    if (batchObj != null) {
                      ref
                          .read(selectedBatchNotifierProvider.notifier)
                          .setSelectedBatch(batchObj);
                    }
                  }
                },
                menuStyle: MenuStyle(
                  visualDensity: VisualDensity.compact,
                  fixedSize: WidgetStateProperty.all(const Size.fromWidth(110)),
                  backgroundColor: WidgetStateProperty.all(theme.cardColor),
                ),
                dropdownMenuEntries: [
                  DropdownMenuEntry<String?>(
                    value: 'all_batches',
                    label: 'All Batches',
                  ),
                  ...batches.map(
                    (b) =>
                        DropdownMenuEntry<String?>(value: b.id, label: b.name),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        width: 110,
        height: 36,
        child: Stack(
          children: [
            Positioned(
              right: 8, top: 0, bottom: 0,
              child: Icon(Icons.keyboard_arrow_down_rounded, size: 16),
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Select Batch',
                contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                isDense: true,
                isCollapsed: true,
              ),
            ),
          ],
        ),
      ),
      error: (e, _) => const Text("Failed to load batches"),
    );
  }
}
