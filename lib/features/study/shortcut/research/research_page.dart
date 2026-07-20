import '/widgets/open_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/research_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/widgets/custom_header_layout.dart';

class ResearchPage extends ConsumerStatefulWidget {
  const ResearchPage({super.key});

  @override
  ConsumerState<ResearchPage> createState() => _ResearchPageState();
}

class _ResearchPageState extends ConsumerState<ResearchPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final notifier = ref.read(researchPaginationProvider.notifier);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          notifier.hasMore) {
        notifier.loadNextPage();
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
    final researchAsync = ref.watch(researchPaginationProvider);
    final notifier = ref.read(researchPaginationProvider.notifier);

    return CustomHeaderLayout(
      title: 'Research Archive',
      showSearchBar: true,
      searchHint: 'Search research...',
      onSearchChanged: (val) {
        ref.read(researchSearchQueryProvider.notifier).state = val;
      },
      body: researchAsync.when(
        data: (researches) {
          if (researches.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => notifier.refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(
                      child: Text(
                        'No research data available yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => notifier.refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              controller: _scrollController,
              itemCount: researches.length + (notifier.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < researches.length) {
                  final research = researches[index];
                  return GestureDetector(
                    onTap: () {
                      if (research.type == 'Publications') {
                        if (kIsWeb) {
                          OpenApp.withUrl(research.webUrl);
                        } else {
                          context.push('/webview?url=${research.webUrl}');
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.md),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
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
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            research.title,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(research.author),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: Text(
                                  research.type,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text('Loading...')),
                  );
                }
              },
            ),
          );
        },
        loading: () {
          return const Center(child: CupertinoActivityIndicator());
        },
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
