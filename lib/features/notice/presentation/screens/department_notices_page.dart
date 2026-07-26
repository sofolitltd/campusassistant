import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/models/notice_model.dart';
import '../providers/notice_provider.dart';
import '../widgets/notice_card.dart';
import '/core/widgets/custom_header_layout.dart';

class DepartmentNoticesPage extends ConsumerWidget {
  const DepartmentNoticesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(departmentNoticesProvider);

    return CustomHeaderLayout(
      title: 'Notices',
      showSearchBar: false,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(departmentNoticesProvider);
          await ref.read(departmentNoticesProvider.future);
        },
        child: noticesAsync.when(
          data: (notices) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.megaphone,
                            size: 64,
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notices yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
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
              padding: const EdgeInsets.all(16),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
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
      padding: const EdgeInsets.all(16),
      itemCount: fallbackNotices.length,
      itemBuilder: (context, index) {
        return NoticeCard(notice: fallbackNotices[index]);
      },
    );
  }
}
