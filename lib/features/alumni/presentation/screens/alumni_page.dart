import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';

import '../providers/alumni_provider.dart';
import '../widgets/alumni_card.dart';
import '../widgets/alumni_empty_state.dart';
import '../widgets/organization_filter_sheet.dart';

class AlumniPage extends ConsumerStatefulWidget {
  const AlumniPage({super.key});

  @override
  ConsumerState<AlumniPage> createState() => _AlumniPageState();
}

class _AlumniPageState extends ConsumerState<AlumniPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scope = ref.read(alumniScopeProvider);
      _tabController.index = scope;
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(alumniScopeProvider.notifier).update(_tabController.index);
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(alumniPaginationProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(alumniSearchQueryProvider.notifier).update(value);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Widget _buildOrgFilterTrailing() {
    final selectedOrg = ref.watch(alumniSelectedOrganizationProvider);
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => showOrganizationFilterSheet(context, ref),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.building2,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Org.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          if (selectedOrg != null)
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => ref
                  .read(alumniSelectedOrganizationProvider.notifier)
                  .update(null),
              child: Padding(
                padding: const EdgeInsets.only(right: 12, left: 2),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.grey.shade500,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alumniStateAsync = ref.watch(alumniPaginationProvider);
    final selectedOrg = ref.watch(alumniSelectedOrganizationProvider);

    return CustomHeaderLayout(
      title: 'Alumni Network',
      searchHint: 'Search alumni...',
      searchTrailing: _buildOrgFilterTrailing(),
      onSearchChanged: _onSearchChanged,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SectionTabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Batch'),
                Tab(text: 'Department'),
                Tab(text: 'University'),
              ],
            ),
          ),
          if (selectedOrg != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.building2,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Filtered by ${selectedOrg.name}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: alumniStateAsync.when(
              data: (state) {
                final alumniList = state.alumni;

                if (alumniList.isEmpty && !state.isLoadingMore) {
                  return const AlumniEmptyState();
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: alumniList.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index == alumniList.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CupertinoActivityIndicator()),
                      );
                    }
                    return AlumniCard(alumni: alumniList[index]);
                  },
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Error: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
