import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/models/notice_model.dart';
import '../providers/notice_provider.dart';
import '../widgets/notice_card.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class DepartmentNoticesPage extends ConsumerStatefulWidget {
  const DepartmentNoticesPage({super.key});

  @override
  ConsumerState<DepartmentNoticesPage> createState() =>
      _DepartmentNoticesPageState();
}

class _DepartmentNoticesPageState extends ConsumerState<DepartmentNoticesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final noticesAsync = ref.watch(departmentNoticesProvider);

    return CustomHeaderLayout(
      title: 'Notices',
      searchAtBottom: true,
      searchHint: 'Search notices...',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(departmentNoticesProvider);
          await ref.read(departmentNoticesProvider.future);
        },
        child: noticesAsync.when(
          data: (notices) {
            if (notices.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            LucideIcons.megaphone,
                            size: 64,
                            color: context.colors.borderStrong,
                          ),
                          const SizedBox(height: Spacing.lg),
                          Text(
                            'No notices yet',
                            style: TextStyle(
                              fontSize: FontSizeToken.xl,
                              fontWeight: .w500,
                              color: context.colors.textSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            final q = _searchQuery.trim().toLowerCase();
            final filtered = q.isEmpty
                ? notices
                : notices
                      .where(
                        (n) =>
                            n.message.toLowerCase().contains(q) ||
                            n.uploader.toLowerCase().contains(q),
                      )
                      .toList();

            if (filtered.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            LucideIcons.searchX,
                            size: 48,
                            color: context.colors.borderStrong,
                          ),
                          const SizedBox(height: Spacing.md),
                          Text(
                            'No matches found',
                            style: TextStyle(
                              color: context.colors.textSubtle,
                              fontWeight: .w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(Spacing.lg),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final notice = filtered[index];
                return NoticeCard(notice: notice);
              },
            );
          },
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: const Center(child: CupertinoActivityIndicator()),
              ),
            ],
          ),
          error: (err, _) => _FallbackNoticeList(),
        ),
      ),
    );
  }
}

class _FallbackNoticeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fallbackNotices = [
      NoticeModel(
        id: '',
        uploader: 'Department Office',
        message:
            'Midterm exam schedule has been published. Check the notice board for details.',
        imageUrl: [],
        time: DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      ),
      NoticeModel(
        id: '',
        uploader: 'Academic Committee',
        message:
            'Classes will remain suspended on Wednesday due to a university-wide holiday.',
        imageUrl: [],
        time: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      ),
      NoticeModel(
        id: '',
        uploader: 'Faculty Advisor',
        message:
            'Project submission deadline extended to next Friday. All group leaders must submit the hard copy to the department office.',
        imageUrl: [],
        time: DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
      ),
    ];

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.all(Spacing.lg),
      itemCount: fallbackNotices.length,
      itemBuilder: (context, index) {
        return NoticeCard(notice: fallbackNotices[index]);
      },
    );
  }
}
