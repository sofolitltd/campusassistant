import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/widgets/pill_tab_bar.dart';
import '/core/widgets/floating_search_bar.dart';
import '/features/emergency/presentation/providers/emergency_provider.dart';
import '/features/emergency/presentation/widgets/contact_card.dart';

class EmergencyPage extends ConsumerStatefulWidget {
  const EmergencyPage({super.key});

  @override
  ConsumerState<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends ConsumerState<EmergencyPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(emergencyScopeProvider.notifier)
            .updateScope(_tabController.index);
      }
    });
  }

  void _onSearchChanged(String query) {
    ref.read(emergencySearchQueryProvider.notifier).updateQuery(query);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Department', 'University', 'National'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: PillTabBar(
                  controller: _tabController,
                  labels: tabs,
                ),
              ),
              // const SizedBox(height: 4),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _EmergencyList(scopeIndex: 0),
                    _EmergencyList(scopeIndex: 1),
                    _EmergencyList(scopeIndex: 2),
                  ],
                ),
              ),
            ],
          ),

          // Premium Floating Bottom Search Bar
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: FloatingSearchBar(
              hintText: 'Search contacts...',
              onChanged: _onSearchChanged,
              debounceMilliseconds: 500,
            ),
          ),
        ],
      ),
    );
  }

}

class _EmergencyList extends ConsumerStatefulWidget {
  final int scopeIndex;
  const _EmergencyList({required this.scopeIndex});

  @override
  ConsumerState<_EmergencyList> createState() => _EmergencyListState();
}

class _EmergencyListState extends ConsumerState<_EmergencyList>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref
            .read(emergencyPaginationProvider(widget.scopeIndex).notifier)
            .loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final emergencyAsync = ref.watch(
      emergencyPaginationProvider(widget.scopeIndex),
    );

    return emergencyAsync.when(
      data: (state) {
        if (state.contacts.isEmpty) {
          return const Center(child: Text('No contacts found'));
        }

        return ListView.separated(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: state.contacts.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.contacts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final contact = state.contacts[index];
            return ContactCard(contact: contact);
          },
          separatorBuilder: (_, _) => const SizedBox(height: 12),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
