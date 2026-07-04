import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/utils/constants.dart';
import '/features/session/presentation/providers/session_provider.dart';
import '/features/blood/presentation/providers/blood_bank_provider.dart';

class BloodBank extends ConsumerStatefulWidget {
  const BloodBank({super.key});

  @override
  ConsumerState<BloodBank> createState() => _BloodBankState();
}

class _BloodBankState extends ConsumerState<BloodBank>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(bloodBankScopeProvider.notifier).update(_tabController.index);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(bloodBankPaginationProvider.notifier).loadMore();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(bloodBankSearchQueryProvider.notifier).update(query);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloodAsync = ref.watch(bloodBankPaginationProvider);
    final selectedBlood = ref.watch(bloodBankSelectedGroupProvider);
    final currentScope = ref.watch(bloodBankScopeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Bank'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 8),

              // Smooth Tabs
              _buildSmoothTabControl(isDark),
              // const SizedBox(height: 4),

              Expanded(
                child: bloodAsync.when(
                  data: (state) {
                    if (state.students.isEmpty && !state.isLoadingMore) {
                      return const Center(child: Text('No donors found.'));
                    }

                    return Column(
                      children: [
                        // Count indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
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
              const SizedBox(height: 8),

                        Expanded(
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            itemCount: state.students.length + (state.hasMore ? 1 : 0),
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              if (index < state.students.length) {
                                final p = state.students[index];
                                return _buildDonorCard(p, currentScope, isDark);
                              } else {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),

          // Floating bottom search and filter bar
          _buildFloatingSearchAndFilter(context, isDark, selectedBlood),
        ],
      ),
    );
  }

  // ── Donor Card ──────────────────────────────────────────────────────────────
  Widget _buildDonorCard(dynamic p, int scope, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                        sessionNameProvider((universityId: p.universityId, id: p.sessionId)),
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
                        sessionNameProvider((universityId: p.universityId, id: p.sessionId)),
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
                        sessionNameProvider((universityId: p.universityId, id: p.sessionId)),
                      );
                      return Text(
                        'Session: $sessionName',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                  if (p.departmentName != null && p.departmentName!.isNotEmpty) ...[
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

                // Scope 3 – National: Name · Session · Department · University
                if (scope == 3) ...[
                  Consumer(
                    builder: (context, ref, _) {
                      final sessionName = ref.watch(
                        sessionNameProvider((universityId: p.universityId, id: p.sessionId)),
                      );
                      return Text(
                        'Session: $sessionName',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                  if (p.departmentName != null && p.departmentName!.isNotEmpty) ...[
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
                  if (p.universityName != null && p.universityName!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      p.universityName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
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

  // ── Tab Control ─────────────────────────────────────────────────────────────
  Widget _buildSmoothTabControl(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: AnimatedBuilder(
          animation: _tabController.animation!,
          builder: (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSmoothTab('Batch', 0, isDark),
                  const SizedBox(width: 4),
                  _buildSmoothTab('Department', 1, isDark),
                  const SizedBox(width: 4),
                  _buildSmoothTab('University', 2, isDark),
                  const SizedBox(width: 4),
                  _buildSmoothTab('National', 3, isDark),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmoothTab(String label, int index, bool isDark) {
    final double animationValue = _tabController.animation!.value;
    final double progress = (1.0 - (animationValue - index).abs()).clamp(0.0, 1.0);

    final Color activeColor = isDark ? Colors.white : Colors.black;
    final Color inactiveColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
    final Color activeTextColor = isDark ? Colors.black : Colors.white;
    final Color inactiveTextColor = Colors.grey.shade600;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        ref.read(bloodBankScopeProvider.notifier).update(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 32,
        decoration: BoxDecoration(
          color: Color.lerp(inactiveColor, activeColor, progress),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color.lerp(
              isDark ? Colors.white24 : Colors.grey.shade300,
              isDark ? Colors.white24 : Colors.grey.shade300,
              progress,
            )!,
            width: 1,
          ),
          boxShadow: progress > 0.5
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.1 * progress),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Color.lerp(inactiveTextColor, activeTextColor, progress),
              fontWeight: progress > 0.5 ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingSearchAndFilter(BuildContext context, bool isDark, String? selectedBlood) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 40,
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
                    onChanged: _onSearchChanged,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search donor name...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Icon(LucideIcons.search, size: 14, color: Colors.grey.shade400),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 32),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _onSearchChanged('');
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(LucideIcons.circleX, size: 14, color: Colors.grey.shade400),
                              ),
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(maxHeight: 28),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                Container(
                  height: 18,
                  width: 1,
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  ),
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
                        ref
                            .read(bloodBankSelectedGroupProvider.notifier)
                            .update(val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

