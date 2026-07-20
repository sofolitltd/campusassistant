import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/syllabus_provider.dart';
import '../../../study/shortcut/syllabus/syllabus_card.dart';
import '/core/widgets/custom_header_layout.dart';

class FullSyllabusPage extends ConsumerStatefulWidget {
  const FullSyllabusPage({super.key});

  @override
  ConsumerState<FullSyllabusPage> createState() => _FullSyllabusPageState();
}

class _FullSyllabusPageState extends ConsumerState<FullSyllabusPage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(syllabusPaginationProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    ref.invalidate(syllabusPaginationProvider);
    await ref.watch(syllabusPaginationProvider.future);
  }

  void _onSearchChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(syllabusSearchQueryProvider.notifier).update(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    final syllabusAsync = ref.watch(syllabusPaginationProvider);

    return CustomHeaderLayout(
      title: 'Full Syllabus',
      showSearchBar: true,
      searchHint: 'Search syllabus...',
      onSearchChanged: _onSearchChanged,
      body: syllabusAsync.when(
        data: (state) {
          if (state.syllabi.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(
                      child: Text(
                        'No syllabus available yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              controller: _scrollController,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemCount: state.syllabi.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < state.syllabi.length) {
                  return SyllabusCard(syllabus: state.syllabi[index]);
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('Loading...')),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
