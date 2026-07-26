import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/features/association/presentation/screens/association_page.dart'
    show AssociationCard;
import '/features/career/circular/presentation/widgets/circular_card.dart';
import '/features/club/presentation/widgets/club_card.dart';
import '/features/course/presentation/screens/course_card.dart'
    show CourseCardContent;
import '/features/lost_found/presentation/widgets/lost_found_card.dart';
import '/features/marketplace/presentation/widgets/product_grid_card.dart';
import '/features/notice/presentation/widgets/notice_card.dart';
import '/features/resource/presentation/widgets/resource_card.dart';
import '/features/resource/presentation/widgets/resource_video_tile.dart';
import '/features/staff/presentation/screens/staff_card.dart';
import '/features/teacher/presentation/widgets/teacher_card.dart';
import '/routes/app_route.dart';
import '../../data/models/search_result.dart';
import '../providers/search_provider.dart';
import '../widgets/search_category_chips.dart';

const _typeLabels = <String, String>{
  'resource': 'Resources',
  'note': 'Notes',
  'book': 'Books',
  'question': 'Questions',
  'syllabus': 'Syllabus',
  'video': 'Video',
  'notice': 'Notices',
  'course': 'Courses',
  'club': 'Clubs',
  'association': 'Associations',
  'teacher': 'Teachers',
  'staff': 'Staff',
  'marketplace': 'Marketplace',
  'lost_found': 'Lost & Found',
  'career': 'Career',
};

// Fixed display order for grouped ("All") results. Resources are broken out
// into their own subtype sections (Notes, Books, ...) rather than one
// combined "Resources" bucket, matching the per-chip filter split.
const _typeOrder = <String>[
  'note',
  'book',
  'question',
  'syllabus',
  'video',
  'notice',
  'course',
  'club',
  'association',
  'teacher',
  'staff',
  'marketplace',
  'lost_found',
  'career',
];

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderLayout(
      title: 'Search',
      searchHint: 'Search courses, clubs, teachers, and more...',
      controller: _controller,
      onSearchChanged: _onSearchChanged,
      onClear: () {
        _debounce?.cancel();
        ref.read(searchQueryProvider.notifier).state = '';
      },
      body: Column(
        children: [
          const SizedBox(height: 8),
          const SearchCategoryChips(),
          const SizedBox(height: 8),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final query = ref.watch(searchQueryProvider).trim();
    final category = ref.watch(searchCategoryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    if (query.length < 2) {
      return _EmptyState(
        icon: LucideIcons.search,
        message: 'Search across resources, clubs, courses and more',
      );
    }

    return resultsAsync.when(
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Something went wrong: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent, fontSize: 13),
          ),
        ),
      ),
      data: (results) {
        if (results == null || results.isEmpty) {
          return _EmptyState(
            icon: LucideIcons.searchX,
            message: 'No results found for "$query"',
          );
        }
        return category == 'all'
            ? _GroupedResultsList(results: results)
            : _FlatResultsList(type: category, results: results);
      },
    );
  }
}

/// Returns the already tap-wired real widgets for [type]'s results — the
/// exact same widgets each entity's own list page uses, so tap behavior
/// (PDF viewer / pro-gate for resources, bottom sheet for notices, detail
/// routes for everything else) matches exactly.
List<Widget> _itemWidgetsForType(
  BuildContext context,
  String type,
  SearchResults results,
) {
  switch (type) {
    case 'resource':
      return [
        for (final r in results.resources)
          ResourceCard(key: ValueKey('resource-${r.id}'), resource: r),
      ];
    // Resource subtypes: same underlying data as 'resource', already
    // filtered down to this subtype by searchResultsProvider when one is
    // selected. 'video' fileUrls are YouTube links, not PDFs, so they get
    // their own tile instead of ResourceCard (which always opens fileUrl in
    // the PDF viewer).
    case 'note':
    case 'book':
    case 'question':
    case 'syllabus':
      return [
        for (final r in results.resources.where((r) => r.type == type))
          ResourceCard(key: ValueKey('resource-${r.id}'), resource: r),
      ];
    case 'video':
      return [
        for (final r in results.resources.where((r) => r.type == 'video'))
          ResourceVideoTile(key: ValueKey('resource-${r.id}'), resource: r),
      ];
    case 'course':
      return [
        for (final c in results.courses)
          InkWell(
            key: ValueKey('course-${c.id}'),
            onTap: () => context.pushNamed(
              AppRoute.courseDetails.name,
              pathParameters: {'courseCode': c.courseCode},
            ),
            child: CourseCardContent(courseModel: c),
          ),
      ];
    case 'notice':
      return [
        for (final n in results.notices)
          NoticeCard(key: ValueKey('notice-${n.id}'), notice: n),
      ];
    case 'club':
      return [
        for (final c in results.clubs)
          ClubCard(key: ValueKey('club-${c.id}'), club: c),
      ];
    case 'association':
      return [
        for (final a in results.associations)
          AssociationCard(key: ValueKey('association-${a.id}'), association: a),
      ];
    case 'teacher':
      return [
        for (final t in results.teachers)
          TeacherCard(key: ValueKey('teacher-${t.id}'), teacher: t),
      ];
    case 'staff':
      return [
        for (final s in results.staffList)
          InkWell(
            key: ValueKey('staff-${s.id}'),
            onTap: () => context.push('/staff/details?id=${s.id}'),
            child: StaffCard(staff: s),
          ),
      ];
    case 'marketplace':
      return [
        for (final p in results.products)
          ProductGridCard(key: ValueKey('marketplace-${p.id}'), product: p),
      ];
    case 'lost_found':
      return [
        for (final item in results.lostFoundItems)
          LostFoundCard(
            key: ValueKey('lost_found-${item.id}'),
            item: item,
            onTap: () => context.pushNamed(
              AppRoute.lostFoundItemDetails.name,
              pathParameters: {'itemId': item.id},
            ),
          ),
      ];
    case 'career':
      return [
        for (final c in results.careerCirculars)
          CircularCard(
            key: ValueKey('career-${c.id}'),
            circular: c,
            onTap: () => context.pushNamed(
              AppRoute.careerCircularDetails.name,
              pathParameters: {'circularId': c.id},
            ),
          ),
      ];
  }
  return const [];
}

/// Marketplace products render as a 2-column grid (their card is designed
/// for that); every other category renders as a single vertical column.
Widget _buildCategoryBody(
  BuildContext context,
  String type,
  List<Widget> items, {
  bool shrinkWrap = false,
}) {
  if (type == 'marketplace') {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }

  if (shrinkWrap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            items[i],
          ],
        ],
      ),
    );
  }

  return ListView.separated(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    itemCount: items.length,
    separatorBuilder: (_, _) => const SizedBox(height: 12),
    itemBuilder: (context, index) => items[index],
  );
}

class _GroupedResultsList extends ConsumerWidget {
  final SearchResults results;
  const _GroupedResultsList({required this.results});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build each section's widgets once and reuse — calling
    // _itemWidgetsForType per section here (instead of once to filter, then
    // again per itemBuilder call) avoids constructing every card twice.
    final sectionItems = {
      for (final type in _typeOrder) type: _itemWidgetsForType(context, type, results),
    }..removeWhere((_, items) => items.isEmpty);
    final sections = sectionItems.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final type = sections[index];
        final items = sectionItems[type]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                _typeLabels[type] ?? type,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildCategoryBody(context, type, items, shrinkWrap: true),
          ],
        );
      },
    );
  }
}

class _FlatResultsList extends ConsumerWidget {
  final String type;
  final SearchResults results;
  const _FlatResultsList({required this.type, required this.results});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _itemWidgetsForType(context, type, results);
    if (items.isEmpty) {
      return _EmptyState(
        icon: LucideIcons.searchX,
        message: 'No ${_typeLabels[type]?.toLowerCase() ?? type} found',
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: _buildCategoryBody(context, type, items),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
