import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/red_header_layout.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/staff/presentation/providers/staff_provider.dart';
import 'staff_card.dart';

class StaffPage extends ConsumerStatefulWidget {
  const StaffPage({super.key});

  @override
  ConsumerState<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends ConsumerState<StaffPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(staffListProvider);
    final userAsync = ref.watch(userProvider);

    return RedHeaderLayout(
      title: 'Office Staff',
      searchHint: 'Search staff...',
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      body: staffAsync.when(
        data: (staffList) {
          // Filter staff by search query
          final filteredStaff = staffList.where((s) {
            if (_searchQuery.isEmpty) return true;
            final q = _searchQuery.toLowerCase();
            return s.name.toLowerCase().contains(q) ||
                s.post.toLowerCase().contains(q) ||
                s.phone.toLowerCase().contains(q);
          }).toList();

          if (filteredStaff.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isNotEmpty
                        ? LucideIcons.searchX
                        : LucideIcons.briefcase,
                    size: 48,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'No matches found'
                        : 'No data found',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final user = userAsync.value;

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            itemCount: filteredStaff.length,
            itemBuilder: (context, index) {
              final staff = filteredStaff[index];
              return StaffCard(staff: staff, user: user);
            },
            separatorBuilder: (_, _) => const SizedBox(height: 15),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
