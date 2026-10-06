import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/widgets/custom_header_layout.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '/features/staff/presentation/providers/staff_provider.dart';
import 'staff_card.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_spacing.dart';

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

    return CustomHeaderLayout(
      title: 'Office Staff',
      searchAtBottom: true,
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
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    _searchQuery.isNotEmpty
                        ? LucideIcons.searchX
                        : LucideIcons.briefcase,
                    size: 48,
                    color: context.colors.borderStrong,
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'No matches found'
                        : 'No data found',
                    style: TextStyle(
                      color: context.colors.textSubtle,
                      fontWeight: .w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final user = userAsync.value;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.lg,
              Spacing.lg,
              Spacing.sm,
            ),
            itemCount: filteredStaff.length,
            itemBuilder: (context, index) =>
                StaffCard(staff: filteredStaff[index], user: user),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
