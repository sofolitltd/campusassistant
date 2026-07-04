import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/syllabus_provider.dart';
import '../../../study/shortcut/syllabus/syllabus_card.dart';

class FullSyllabusPage extends ConsumerStatefulWidget {
  const FullSyllabusPage({super.key});

  @override
  ConsumerState<FullSyllabusPage> createState() => _FullSyllabusPageState();
}

class _FullSyllabusPageState extends ConsumerState<FullSyllabusPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    ref.invalidate(syllabusPaginationProvider);
    await ref.watch(syllabusPaginationProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final syllabusAsync = ref.watch(syllabusPaginationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Syllabus'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          syllabusAsync.when(
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  controller: _scrollController,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemCount:
                      state.syllabi.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.syllabi.length) {
                      return SyllabusCard(
                        syllabus: state.syllabi[index],
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('Loading...')),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade300,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            if (_debounce?.isActive ?? false) _debounce!.cancel();
                            _debounce = Timer(
                              const Duration(milliseconds: 500),
                              () {
                                ref
                                    .read(syllabusSearchQueryProvider.notifier)
                                    .update(val);
                              },
                            );
                          },
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search syllabus...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 8),
                              child: Icon(
                                LucideIcons.search,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 32),
                            suffixIcon:
                                _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          ref
                                              .read(
                                                  syllabusSearchQueryProvider
                                                      .notifier)
                                              .update('');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Icon(
                                            LucideIcons.circleX,
                                            size: 14,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      )
                                    : null,
                            suffixIconConstraints:
                                const BoxConstraints(maxHeight: 28),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
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
