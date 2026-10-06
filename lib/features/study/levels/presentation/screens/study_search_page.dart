import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/app_choice_chip.dart';
import '/core/widgets/custom_header_layout.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/course/presentation/screens/course_card.dart'
    show CourseCardContent;
import '/features/resource/presentation/widgets/resource_card.dart';
import '/features/resource/presentation/widgets/resource_video_tile.dart';
import '/features/search/data/models/search_result.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

const _typeLabels = <String, String>{
  'note': 'Notes',
  'book': 'Books',
  'question': 'Questions',
  'syllabus': 'Syllabus',
  'video': 'Video',
  'course': 'Courses',
};

const _typeOrder = <String>[
  'course',
  'note',
  'book',
  'question',
  'syllabus',
  'video',
];

const _categories = <(String key, String label)>[
  ('all', 'All'),
  ('course', 'Courses'),
  ('note', 'Notes'),
  ('book', 'Books'),
  ('question', 'Questions'),
  ('syllabus', 'Syllabus'),
  ('video', 'Video'),
];

const _resourceSubtypes = <String>{
  'note',
  'book',
  'question',
  'syllabus',
  'video',
};

class StudySearchPage extends ConsumerStatefulWidget {
  const StudySearchPage({super.key});

  @override
  ConsumerState<StudySearchPage> createState() => _StudySearchPageState();
}

class _StudySearchPageState extends ConsumerState<StudySearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String _category = 'all';
  Future<SearchResults?>? _resultsFuture;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _search(value);
    });
  }

  void _search(String value) {
    setState(() {
      _query = value;
      _resultsFuture = _fetchResults(value);
    });
  }

  Future<SearchResults?> _fetchResults(String value) async {
    final trimmed = value.trim();
    if (trimmed.length < 2) return null;

    final repo = ref.read(searchRepositoryProvider);
    final profile = await ref.read(userProvider.future);

    final isSubtype = _resourceSubtypes.contains(_category);
    final results = await repo.search(
      query: trimmed,
      types: ['resource', 'course'],
      universityId: profile.university,
      departmentId: profile.department,
      limitPerType: isSubtype ? 20 : null,
    );

    if (!isSubtype) return results;
    return results.copyWith(
      resources: results.resources.where((r) => r.type == _category).toList(),
    );
  }

  @override
  Widget build(BuildContext context) => CustomHeaderLayout(
    glassSearch: true,
    title: 'Search Study',
    searchHint: 'Search courses, notes, books...',
    controller: _controller,
    onSearchChanged: _onSearchChanged,
    onClear: () {
      _debounce?.cancel();
      setState(() {
        _query = '';
        _resultsFuture = null;
      });
    },
    body: Column(
      children: [
        const SizedBox(height: Spacing.sm),
        _StudyCategoryChips(
          selected: _category,
          onSelected: (key) {
            setState(() {
              _category = key;
              _resultsFuture = _fetchResults(_query);
            });
          },
        ),
        const SizedBox(height: Spacing.sm),
        Expanded(child: _buildBody()),
      ],
    ),
  );

  Widget _buildBody() {
    if (_query.trim().length < 2) {
      return _EmptyState(
        icon: LucideIcons.search,
        message: 'Search courses, notes, books and more',
      );
    }

    final future = _resultsFuture;
    if (future == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return FutureBuilder<SearchResults?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xl),
              child: Text(
                'Something went wrong: ${snapshot.error}',
                textAlign: .center,
                style: TextStyle(
                  color: context.colors.danger,
                  fontSize: FontSizeToken.md,
                ),
              ),
            ),
          );
        }
        final results = snapshot.data;
        if (results == null || results.isEmpty) {
          return _EmptyState(
            icon: LucideIcons.searchX,
            message: 'No results found for "${_query.trim()}"',
          );
        }
        return _category == 'all'
            ? _GroupedResultsList(results: results)
            : _FlatResultsList(type: _category, results: results);
      },
    );
  }
}

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
  }
  return const [];
}

Widget _buildCategoryBody(
  BuildContext context,
  List<Widget> items, {
  bool shrinkWrap = false,
}) {
  if (shrinkWrap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: Spacing.md),
            items[i],
          ],
        ],
      ),
    );
  }

  return ListView.separated(
    padding: const EdgeInsets.fromLTRB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
    itemCount: items.length,
    separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
    itemBuilder: (context, index) => items[index],
  );
}

class _GroupedResultsList extends ConsumerWidget {
  final SearchResults results;
  const _GroupedResultsList({required this.results});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionItems = {
      for (final type in _typeOrder)
        type: _itemWidgetsForType(context, type, results),
    }..removeWhere((_, items) => items.isEmpty);
    final sections = sectionItems.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final type = sections[index];
        final items = sectionItems[type]!;
        return Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.md,
                Spacing.lg,
                Spacing.sm,
              ),
              child: Text(
                _typeLabels[type] ?? type,
                style: TextStyle(
                  fontSize: FontSizeToken.sm,
                  fontWeight: .bold,
                  color: context.colors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildCategoryBody(context, items, shrinkWrap: true),
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
      padding: const EdgeInsets.only(top: Spacing.sm),
      child: _buildCategoryBody(context, items),
    );
  }
}

class _StudyCategoryChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _StudyCategoryChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppChoiceChip.rowHeight,
      child: ListView.separated(
        scrollDirection: .horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          final (key, label) = _categories[index];
          return AppChoiceChip(
            label: label,
            selected: selected == key,
            onTap: () => onSelected(key),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Spacing.xxl),
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 48, color: context.colors.borderStrong),
          const SizedBox(height: Spacing.md),
          Text(
            message,
            textAlign: .center,
            style: TextStyle(
              color: context.colors.textSubtle,
              fontWeight: .w500,
            ),
          ),
        ],
      ),
    ),
  );
}
