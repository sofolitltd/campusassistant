import '/widgets/open_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/research_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

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
                    child: Center(
                      child: Text(
                        'No research data available yet.',
                        style: TextStyle(color: context.colors.textSubtle),
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
              padding: const EdgeInsets.fromLTRB(
                Spacing.lg,
                Spacing.lg,
                Spacing.lg,
                Spacing.lg,
              ),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: Spacing.md),
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
                              ? context.colors.border
                              : context.colors.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(Spacing.md),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            research.title,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(fontWeight: .bold),
                          ),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            crossAxisAlignment: .baseline,
                            textBaseline: .alphabetic,
                            children: [
                              Text(research.author),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.xs,
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.sm,
                                  vertical: Spacing.xxs,
                                ),
                                child: Text(
                                  research.type,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: context.colors.onPrimary,
                                      ),
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
                    padding: EdgeInsets.symmetric(vertical: Spacing.lg),
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
