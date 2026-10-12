import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/core/widgets/inline_search_bar.dart';
import '/core/widgets/missing_placement_card.dart';
import '/core/widgets/not_added_notice.dart';
import '/features/batch/presentation/providers/batch_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/routes/app_route.dart';
import '../providers/placement_selection_provider.dart';

/// First step of the document-based sign-up: pick university, department and
/// batch, and tell the student right away — before they create an account —
/// if their batch hasn't been added to the system yet, instead of letting
/// them fill in the whole form only to get stuck.
class PlacementSelectionScreen extends ConsumerStatefulWidget {
  const PlacementSelectionScreen({super.key});

  @override
  ConsumerState<PlacementSelectionScreen> createState() =>
      _PlacementSelectionScreenState();
}

class _PlacementSelectionScreenState
    extends ConsumerState<PlacementSelectionScreen> {
  String? _universityId;
  String? _universityName;
  String? _departmentId;
  String? _departmentName;
  String? _batchId;
  String? _batchName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = MediaQuery.of(context).size.width;

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: colors.onPrimary),
          title: Text(
            'Find Your Batch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.onPrimary,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxxl),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: Spacing.xl,
              horizontal: width > 800 ? width * .3 : Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select your university, department and batch. If we '
                  "haven't added it to the system yet, we'll let you know "
                  'how to reach us.',
                  style: TextStyle(
                    fontSize: FontSizeToken.base,
                    color: colors.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: Spacing.xxl),
                ..._cascadeFields(),
                // Reserve the space the sticky footer below will cover so
                // the last picker field never sits hidden behind it.
                const SizedBox(height: Spacing.xxxxl * 3),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxl),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxl),
            ),
            child: SafeArea(
              minimum: EdgeInsets.symmetric(
                horizontal: width > 800 ? width * .3 : Spacing.lg,
                vertical: Spacing.lg,
              ),
              child: _batchId == null
                  ? const MissingPlacementCard()
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          ControlToken.height,
                        ),
                      ),
                      onPressed: () {
                        ref.read(placementSelectionProvider.notifier).set(
                          PlacementSelection(
                            universityId: _universityId!,
                            departmentId: _departmentId!,
                            batchId: _batchId!,
                          ),
                        );
                        context.pushNamed(AppRoute.documentSignup.name);
                      },
                      icon: Icon(
                        LucideIcons.arrowRight,
                        size: 18,
                        color: colors.onPrimary,
                      ),
                      label: const Text('Register'),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  List<({String id, String name})> _sortedPickerItems(
    Iterable<({String id, String name})> items,
  ) {
    final list = items.toList();
    list.sort((a, b) {
      final an = int.tryParse(RegExp(r'\d+').firstMatch(a.name)?.group(0) ?? '');
      final bn = int.tryParse(RegExp(r'\d+').firstMatch(b.name)?.group(0) ?? '');
      if (an != null && bn != null) return bn.compareTo(an);
      return b.name.compareTo(a.name);
    });
    return list;
  }

  Widget _pickerOptionTile({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: isSelected ? colors.primary : colors.text,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colors.primary, size: 16),
          ],
        ),
      ),
    );
  }

  void _showPickerSheet({
    required String title,
    required String searchHint,
    required String notFoundWhat,
    required List<({String id, String name})> items,
    required String? selectedId,
    required void Function(String id, String name) onSelected,
    bool asGrid = false,
  }) {
    String searchText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusToken.xxl)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = searchText.isEmpty
                ? items
                : items
                      .where(
                        (i) => i.name.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ),
                      )
                      .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.colors.borderStrong,
                          borderRadius: BorderRadius.circular(RadiusToken.xs),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: FontSizeToken.xl,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              LucideIcons.x,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                      child: InlineSearchBar(
                        hintText: searchHint,
                        onChanged: (v) => setSheetState(() => searchText = v),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Expanded(
                      child: filtered.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.xl,
                              ),
                              child: NotAddedNotice(what: notFoundWhat),
                            )
                          : asGrid
                          ? GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                Spacing.xl,
                                0,
                                Spacing.xl,
                                Spacing.xl,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: Spacing.sm,
                                    crossAxisSpacing: Spacing.sm,
                                    childAspectRatio: 3.2,
                                  ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = item.id == selectedId;
                                return _pickerOptionTile(
                                  name: item.name,
                                  isSelected: isSelected,
                                  onTap: () {
                                    onSelected(item.id, item.name);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                Spacing.xl,
                                0,
                                Spacing.xl,
                                Spacing.xl,
                              ),
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: Spacing.xs),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = item.id == selectedId;
                                return ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      RadiusToken.md,
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? context.colors.primary
                                          : context.colors.border,
                                    ),
                                  ),
                                  title: Text(item.name),
                                  trailing: isSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          color: context.colors.primary,
                                          size: 18,
                                        )
                                      : null,
                                  onTap: () {
                                    onSelected(item.id, item.name);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _pickerField({
    required String label,
    required String? value,
    required VoidCallback onTap,
    bool enabled = true,
    bool loading = false,
  }) {
    final colors = context.colors;
    return GestureDetector(
      onTap: (enabled && !loading) ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: enabled ? Theme.of(context).cardColor : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.md),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: !enabled
                      ? colors.textSubtle
                      : value == null
                      ? colors.textSubtle
                      : colors.text,
                  fontWeight: value == null
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),
            ),
            if (loading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.textMuted,
                ),
              )
            else
              Icon(Icons.keyboard_arrow_down, size: 18, color: colors.textMuted),
          ],
        ),
      ),
    );
  }

  /// University → department → batch cascade. Every field stays visible;
  /// a field is disabled until its prerequisite is chosen, and a step whose
  /// options come back empty shows a "not added yet" notice instead.
  List<Widget> _cascadeFields() {
    return [
      ref
          .watch(allUniversitiesProvider)
          .when(
            data: (list) => list.isEmpty
                ? const NotAddedNotice(what: 'any university')
                : _pickerField(
                    label: 'Select Your University',
                    value: _universityName,
                    onTap: () => _showPickerSheet(
                      title: 'Select University',
                      searchHint: 'Search University...',
                      notFoundWhat: 'your university',
                      items: [for (final u in list) (id: u.id, name: u.name)],
                      selectedId: _universityId,
                      onSelected: (id, name) => setState(() {
                        _universityId = id;
                        _universityName = name;
                        _departmentId = null;
                        _departmentName = null;
                        _batchId = null;
                        _batchName = null;
                      }),
                    ),
                  ),
            loading: () => _pickerField(
              label: 'Select Your University',
              value: null,
              enabled: false,
              loading: true,
              onTap: () {},
            ),
            error: (e, _) => Text('Could not load: $e'),
          ),
      const SizedBox(height: Spacing.sm),
      _universityId == null
          ? _pickerField(
              label: 'Select Your Department',
              value: null,
              enabled: false,
              onTap: () {},
            )
          : ref
                .watch(departmentsByUniversityProvider(_universityId!))
                .when(
                  data: (list) => list.isEmpty
                      ? const NotAddedNotice(what: 'your department')
                      : _pickerField(
                          label: 'Select Your Department',
                          value: _departmentName,
                          onTap: () => _showPickerSheet(
                            title: 'Select Department',
                            searchHint: 'Search Department...',
                            notFoundWhat: 'your department',
                            items: [
                              for (final d in list) (id: d.id, name: d.name),
                            ],
                            selectedId: _departmentId,
                            onSelected: (id, name) => setState(() {
                              _departmentId = id;
                              _departmentName = name;
                              _batchId = null;
                              _batchName = null;
                            }),
                          ),
                        ),
                  loading: () => _pickerField(
                    label: 'Select Your Department',
                    value: null,
                    enabled: false,
                    loading: true,
                    onTap: () {},
                  ),
                  error: (e, _) => Text('Could not load: $e'),
                ),
      const SizedBox(height: Spacing.sm),
      _departmentId == null
          ? _pickerField(
              label: 'Select Your Batch',
              value: null,
              enabled: false,
              onTap: () {},
            )
          : ref
                .watch(batchesByDepartmentProvider(_departmentId!))
                .when(
                  data: (list) => list.isEmpty
                      ? const NotAddedNotice(what: 'your batch')
                      : _pickerField(
                          label: 'Select Your Batch',
                          value: _batchName,
                          onTap: () => _showPickerSheet(
                            title: 'Select Batch',
                            searchHint: 'Search Batch...',
                            notFoundWhat: 'your batch',
                            asGrid: true,
                            items: _sortedPickerItems([
                              for (final b in list) (id: b.id, name: b.name),
                            ]),
                            selectedId: _batchId,
                            onSelected: (id, name) => setState(() {
                              _batchId = id;
                              _batchName = name;
                            }),
                          ),
                        ),
                  loading: () => _pickerField(
                    label: 'Select Your Batch',
                    value: null,
                    enabled: false,
                    loading: true,
                    onTap: () {},
                  ),
                  error: (e, _) => Text('Could not load: $e'),
                ),
    ];
  }
}
