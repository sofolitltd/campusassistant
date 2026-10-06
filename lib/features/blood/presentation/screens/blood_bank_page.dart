import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/app_choice_chip.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/glass_search_bar.dart';
import '/core/widgets/numbered_pagination.dart';
import '/core/widgets/section_tab_bar.dart';
import '/utils/constants.dart';
import '/features/session/presentation/providers/session_provider.dart';
import '/features/blood/presentation/providers/blood_bank_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class BloodBank extends ConsumerStatefulWidget {
  const BloodBank({super.key});

  @override
  ConsumerState<BloodBank> createState() => _BloodBankState();
}

class _BloodBankState extends ConsumerState<BloodBank>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(bloodBankScopeProvider.notifier).update(_tabController.index);
        setState(() => _currentPage = 1);
      }
    });
  }

  void _onSearchChanged(String query) {
    ref.read(bloodBankSearchQueryProvider.notifier).update(query);
    setState(() => _currentPage = 1);
  }

  void _openBloodFilter() {
    final colors = context.colors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusToken.xxxl),
        ),
      ),
      builder: (sheetContext) => Consumer(
        builder: (context, ref, _) {
          final selected = ref.watch(bloodBankSelectedGroupProvider);
          void pick(String? group) {
            ref.read(bloodBankSelectedGroupProvider.notifier).update(group);
            setState(() => _currentPage = 1);
            Navigator.pop(sheetContext);
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Blood group',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.sm,
                    children: [
                      AppChoiceChip(
                        label: 'All',
                        selected: selected == null,
                        onTap: () => pick(null),
                      ),
                      for (final group in kBloodGroup)
                        AppChoiceChip(
                          label: group,
                          selected: selected == group,
                          onTap: () => pick(group),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _setPage(int page) => setState(() => _currentPage = page);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageAsync = ref.watch(bloodBankPageProvider(_currentPage));
    final currentScope = ref.watch(bloodBankScopeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomHeaderLayout(
      searchAtBottom: true,
      title: 'Blood Bank',
      searchHint: 'Search donor name...',
      onSearchChanged: _onSearchChanged,
      searchAction: GlassCircleButton(
        icon: LucideIcons.slidersHorizontal,
        tooltip: 'Filter by blood group',
        active: ref.watch(bloodBankSelectedGroupProvider) != null,
        onTap: _openBloodFilter,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.lg,
              Spacing.lg,
              Spacing.sm,
            ),
            child: SectionTabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Batch'),
                Tab(text: 'Department'),
                Tab(text: 'University'),
              ],
            ),
          ),
          Expanded(
            child: pageAsync.when(
              data: (state) {
                if (state.students.isEmpty) {
                  return const Center(child: Text('No donors found.'));
                }

                final totalPages = (state.total / bloodBankPageSize).ceil();
                final startIndex = (_currentPage - 1) * bloodBankPageSize + 1;
                final endIndex = (startIndex + state.students.length - 1).clamp(
                  0,
                  state.total,
                );

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          totalPages > 1 ? 0 : 16,
                        ),
                        itemCount: totalPages > 1
                            ? state.students.length + 1
                            : state.students.length,
                        separatorBuilder: (_, index) {
                          if (totalPages > 1 &&
                              index == state.students.length - 1) {
                            return const SizedBox(height: 0);
                          }
                          return const SizedBox(height: Spacing.md);
                        },
                        itemBuilder: (context, index) {
                          if (totalPages > 1 &&
                              index == state.students.length) {
                            return NumberedPagination(
                              currentPage: _currentPage,
                              totalPages: totalPages,
                              totalItems: state.total,
                              startIndex: startIndex,
                              endIndex: endIndex,
                              onPageChanged: _setPage,
                            );
                          }
                          final p = state.students[index];
                          return _buildDonorCard(p, currentScope, isDark);
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  // ── Donor Card ──────────────────────────────────────────────────────────────
  Widget _buildDonorCard(dynamic p, int scope, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Spacing.md,
              horizontal: Spacing.md,
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // Name — always shown
                Text(
                  p.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                ),
                const SizedBox(height: Spacing.xs),

                // Scope 0 – Batch: Name · ID · Session
                if (scope == 0) ...[
                  Text(
                    'ID: ${p.studentId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Consumer(
                    builder: (context, ref, _) {
                      final sessionName = ref.watch(
                        sessionNameProvider((
                          universityId: p.universityId,
                          id: p.sessionId,
                        )),
                      );
                      return Text(
                        'Session: $sessionName',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ],

                // Scope 1 – Department: Name · Session · Batch
                if (scope == 1) ...[
                  Consumer(
                    builder: (context, ref, _) {
                      final sessionName = ref.watch(
                        sessionNameProvider((
                          universityId: p.universityId,
                          id: p.sessionId,
                        )),
                      );
                      return Text(
                        'Session: $sessionName',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                  if (p.batchName != null && p.batchName!.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      p.batchName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ],

                // Scope 2 – University: Name · Session · Department
                if (scope == 2) ...[
                  Consumer(
                    builder: (context, ref, _) {
                      final sessionName = ref.watch(
                        sessionNameProvider((
                          universityId: p.universityId,
                          id: p.sessionId,
                        )),
                      );
                      return Text(
                        'Session: $sessionName',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                  if (p.departmentName != null &&
                      p.departmentName!.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      p.departmentName!,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),

          // Blood Group Badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.colors.danger,
                borderRadius: BorderRadius.circular(RadiusToken.sm),
                border: Border.all(color: context.colors.danger),
              ),
              child: Text(
                p.bloodGroup,
                style: TextStyle(
                  color: context.colors.onDanger,
                  fontWeight: .bold,
                  fontSize: FontSizeToken.sm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
