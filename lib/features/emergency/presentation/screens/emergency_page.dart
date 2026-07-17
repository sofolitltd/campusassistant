import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/widgets/red_header_layout.dart';
import '/core/widgets/section_tab_bar.dart';
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

    return RedHeaderLayout(
      title: 'Emergency Contacts',
      searchHint: 'Search contacts...',
      onSearchChanged: _onSearchChanged,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SectionTabBar(
              controller: _tabController,
              tabs: tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _EmergencyList(scopeIndex: 0),
                _EmergencyList(scopeIndex: 1),
                _EmergencyList(scopeIndex: 2),
              ],
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
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            final contact = state.contacts[index];
            return ContactCard(contact: contact);
          },
          separatorBuilder: (_, _) => const SizedBox(height: 12),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
