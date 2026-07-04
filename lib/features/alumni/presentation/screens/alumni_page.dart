import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/widgets/pill_tab_bar.dart';

import '../providers/alumni_provider.dart';
import '../widgets/alumni_card.dart';
import '../widgets/alumni_empty_state.dart';
import '../widgets/floating_search_bar.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

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

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alumniStateAsync = ref.watch(alumniPaginationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alumni Network',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 8),
              PillTabBar(
                controller: _tabController,
                labels: const ['Batch', 'Department', 'University', 'National'],
                onTap: (index) {
                  ref.read(alumniScopeProvider.notifier).update(index);
                },
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: alumniList.length + (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        if (index == alumniList.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return AlumniCard(alumni: alumniList[index]);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
          FloatingSearchBar(
            onFilterTap: () => showOrganizationFilterSheet(context, ref),
          ),
        ],
      ),
    );
  }
}
