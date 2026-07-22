import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/core/widgets/numbered_pagination.dart';
import '/core/widgets/section_tab_bar.dart';
import '/utils/constants.dart';
import '/features/session/presentation/providers/session_provider.dart';
import '/features/blood/presentation/providers/blood_bank_provider.dart';
import '/core/theme/tokens/app_radius.dart';

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
      title: 'Blood Bank',
      searchHint: 'Search donor name...',
      onSearchChanged: _onSearchChanged,
      searchTrailing: _BloodGroupDropdown(
        onChanged: () => setState(() => _currentPage = 1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                final endIndex = (startIndex + state.students.length - 1)
                    .clamp(0, state.total);

                return Column(
                  children: [
                    // Count indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Showing ${state.students.length} / ${state.total}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
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
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          if (totalPages > 1 && index == state.students.length) {
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
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name — always shown
                Text(
                  p.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                // Scope 0 – Batch: Name · ID · Session
                if (scope == 0) ...[
                  Text(
                    'ID: ${p.studentId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 2),
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
                    const SizedBox(height: 2),
                    Text(
                      p.batchName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
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
                    const SizedBox(height: 2),
                    Text(
                      p.departmentName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Text(
                p.bloodGroup,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Blood group filter dropdown used as trailing widget in the search bar.
class _BloodGroupDropdown extends ConsumerWidget {
  const _BloodGroupDropdown({required this.onChanged});

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedBlood = ref.watch(bloodBankSelectedGroupProvider);

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(canvasColor: isDark ? const Color(0xFF1E1E1E) : Colors.white),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedBlood,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Blood',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          icon: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(LucideIcons.chevronDown, size: 12),
          ),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'All',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
            ),
            ...kBloodGroup.map(
              (group) => DropdownMenuItem<String?>(
                value: group,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    group,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ],
          onChanged: (val) {
            ref.read(bloodBankSelectedGroupProvider.notifier).update(val);
            onChanged();
          },
        ),
      ),
    );
  }
}
