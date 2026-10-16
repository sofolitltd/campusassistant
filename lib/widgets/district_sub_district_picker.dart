import 'package:collection/collection.dart';
import 'package:material_ui/material_ui.dart';

import '/core/theme/app_colors.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/association/data/models/bd_district.dart';
import '/features/association/presentation/providers/bd_district_provider.dart';
import '/core/theme/tokens/app_spacing.dart';

/// Reusable district → sub-district (upazila) cascading picker, backed by
/// the shared [bdDistrictsProvider]. Extracted from the district/sub-district
/// dropdowns in suggest_association_page.dart so student-address entry
/// doesn't duplicate the pattern.
class DistrictSubDistrictPicker extends ConsumerWidget {
  final String? districtId;
  final String? subDistrictId;
  final ValueChanged<BDDistrict?> onDistrictChanged;
  final ValueChanged<BDSubDistrict?> onSubDistrictChanged;

  const DistrictSubDistrictPicker({
    super.key,
    required this.districtId,
    required this.subDistrictId,
    required this.onDistrictChanged,
    required this.onSubDistrictChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final districtsAsync = ref.watch(bdDistrictsProvider);

    return districtsAsync.when(
      data: (districts) {
        final selectedDistrict = districts.firstWhereOrNull(
          (d) => d.id == districtId,
        );
        final selectedSubDistrict = selectedDistrict?.subDistricts
            .firstWhereOrNull((s) => s.id == subDistrictId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('District'),
            const SizedBox(height: Spacing.sm),
            DropdownButtonFormField<BDDistrict>(
              initialValue: selectedDistrict,
              decoration: const InputDecoration(hintText: 'Select district'),
              items: districts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                  .toList(),
              onChanged: (v) {
                onDistrictChanged(v);
                onSubDistrictChanged(null);
              },
            ),
            const SizedBox(height: Spacing.md),
            const Text('Sub-district (optional)'),
            const SizedBox(height: Spacing.sm),
            DropdownButtonFormField<BDSubDistrict>(
              initialValue: selectedSubDistrict,
              decoration: const InputDecoration(
                hintText: 'Select sub-district',
              ),
              items: (selectedDistrict?.subDistricts ?? [])
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: selectedDistrict == null ? null : onSubDistrictChanged,
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: Spacing.lg),
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, _) => Text(
        'Failed to load districts.',
        style: TextStyle(color: context.colors.danger),
      ),
    );
  }
}
