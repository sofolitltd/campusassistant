import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/association/data/models/bd_district.dart';
import '/features/association/presentation/providers/bd_district_provider.dart';

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
          children: [
            DropdownButtonFormField<BDDistrict>(
              initialValue: selectedDistrict,
              decoration: const InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
              ),
              items: districts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                  .toList(),
              onChanged: (v) {
                onDistrictChanged(v);
                onSubDistrictChanged(null);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BDSubDistrict>(
              initialValue: selectedSubDistrict,
              decoration: const InputDecoration(
                labelText: 'Sub-district (optional)',
                border: OutlineInputBorder(),
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
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, _) => Text(
        'Failed to load districts.',
        style: TextStyle(color: Colors.red.shade400),
      ),
    );
  }
}
