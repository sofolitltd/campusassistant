import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'batch_students_page.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/app_loader.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/glass_search_bar.dart';
import '/core/widgets/section_tab_bar.dart';
import '/features/batch/domain/entities/batch.dart';
import '/features/batch/presentation/providers/batch_list_provider.dart';
import '/features/batch/presentation/providers/program_provider.dart';
import '/features/batch/presentation/widgets/batch_cover.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/features/student/presentation/widgets/student_paged_list.dart';

/// Students: a grid of batch cards (grouped Honors / Masters when the
/// department has both); a card opens that batch's list. Typing a search
/// swaps the grid for a search across the whole department.
class AllStudentsPage extends ConsumerStatefulWidget {
  const AllStudentsPage({super.key});

  @override
  ConsumerState<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends ConsumerState<AllStudentsPage> {
  // Sent to the server (name / student ID / phone / email).
  String _searchQuery = '';
  Timer? _searchDebounce;

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() => _searchQuery = value.trim());
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final batchesAsync = ref.watch(batchProviderAll);

    return CustomHeaderLayout(
      title: 'All Students',
      searchAtBottom: true,
      searchHint: 'Search by name, ID or phone...',
      onSearchChanged: _onSearchChanged,
      body: batchesAsync.when(
        data: (batches) {
          if (batches.isEmpty) {
            return const Center(child: Text('No batches found!'));
          }
          if (_searchQuery.isNotEmpty) {
            return StudentPagedList(
              universityId: batches.first.universityId,
              departmentId: batches.first.departmentId,
              batchName: 'All',
              search: _searchQuery,
            );
          }
          return _BatchGrid(batches: batches);
        },
        loading: () => const Center(child: AppLoader()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

/// The batch cards under Honors | Masters tabs (always both, swipeable),
/// opening on the student's own program. Beside the tabs, an "All" button
/// opens every student of the department as one list.
class _BatchGrid extends ConsumerStatefulWidget {
  const _BatchGrid({required this.batches});

  final List<Batch> batches;

  @override
  ConsumerState<_BatchGrid> createState() => _BatchGridState();
}

class _BatchGridState extends ConsumerState<_BatchGrid>
    with SingleTickerProviderStateMixin {
  // Fixed order, matching Study's program switch and the admin tabs.
  static const _programs = ['honours', 'masters'];

  late final TabController _tabController = TabController(
    length: _programs.length,
    vsync: this,
  );
  // Opened on the student's own program once — never again after that, so
  // a late-loading profile can't yank the tab out from under them.
  bool _openedOnOwnProgram = false;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(studentCountByBatchProvider);
    ref.invalidate(studentCountAllProvider);
    ref.invalidate(batchProviderAll);
    await ref.read(batchProviderAll.future);
  }

  @override
  Widget build(BuildContext context) {
    final mine = ref.watch(myProgramsProvider).value;
    final myBatchIds = <String>{...?mine?.all.map((p) => p.batchId)};
    final currentProgram = mine?.current?.program;

    if (!_openedOnOwnProgram && currentProgram != null) {
      _openedOnOwnProgram = true;
      final own = _programs.indexOf(currentProgram);
      if (own > 0) {
        // Not during build: moving the controller rebuilds the tab bar.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tabController.index = own;
        });
      }
    }

    // Plain newest-first by batch number (Batch 16, 15, 14 …). The
    // student's own batch is marked on its card, not moved.
    final byProgram = {
      for (final p in _programs)
        p: widget.batches.where((b) => b.program == p).toList()
          ..sort((a, b) => batchNumber(b).compareTo(batchNumber(a))),
    };

    final first = widget.batches.first;
    final allCount = ref
        .watch(
          studentCountAllProvider(
            universityId: first.universityId,
            departmentId: first.departmentId,
          ),
        )
        .value;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.lg,
            Spacing.lg,
            0,
          ),
          child: Row(
            children: [
              Expanded(
                child: SectionTabBar(
                  controller: _tabController,
                  tabs: [
                    for (final p in _programs)
                      Tab(text: '${programLabel(p)} (${byProgram[p]!.length})'),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              _AllStudentsButton(
                count: allCount,
                onTap: () => context.pushNamed(
                  'batchStudents',
                  pathParameters: {'batch': BatchStudentsPage.all},
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              for (final p in _programs) _grid(byProgram[p]!, myBatchIds, p),
            ],
          ),
        ),
      ],
    );
  }

  Widget _grid(List<Batch> items, Set<String> myBatchIds, String program) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: Spacing.xxxxl),
          children: [
            Center(
              child: Text(
                'No ${programLabel(program)} batches yet',
                style: TextStyle(color: context.colors.textSubtle),
              ),
            ),
          ],
        ),
      );
    }
    // Two columns on phones, three on wider screens; each card is a 16:9
    // cover plus two lines of text.
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 600 ? 3 : 2;
    final cardWidth =
        (width - Spacing.lg * 2 - Spacing.md * (columns - 1)) / columns;
    final textScaler = MediaQuery.textScalerOf(context);
    final cardHeight =
        cardWidth * 9 / 16 +
        Spacing.sm +
        Spacing.md +
        textScaler.scale(FontSizeToken.base) * 1.4 +
        Spacing.xxs +
        textScaler.scale(FontSizeToken.xs) * 1.4 +
        4;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          Spacing.lg,
          Spacing.lg,
          Spacing.lg,
          GlassSearchBar.listBottomPadding(context),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: Spacing.md,
          crossAxisSpacing: Spacing.md,
          mainAxisExtent: cardHeight,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => _BatchTile(
          batch: items[i],
          isMine: myBatchIds.contains(items[i].id),
        ),
      ),
    );
  }
}

/// Opens the whole department's student list; shows the total.
class _AllStudentsButton extends StatelessWidget {
  const _AllStudentsButton({required this.count, required this.onTap});

  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = this.count;
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(color: context.colors.borderStrong),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(LucideIcons.users, size: 16, color: context.colors.primary),
              const SizedBox(width: Spacing.xs),
              Text(
                count == null ? 'All' : 'All ($count)',
                style: TextStyle(
                  fontSize: FontSizeToken.md,
                  fontWeight: .w700,
                  color: context.colors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Watches its own count, so only the cards on screen ask for one.
class _BatchTile extends ConsumerWidget {
  const _BatchTile({required this.batch, required this.isMine});

  final Batch batch;
  final bool isMine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(studentCountByBatchProvider(batch.id)).value;
    return BatchCoverCard(
      batch: batch,
      studentCount: count,
      isMine: isMine,
      onTap: () => context.pushNamed(
        'batchStudents',
        pathParameters: {'batch': batch.id},
      ),
    );
  }
}
