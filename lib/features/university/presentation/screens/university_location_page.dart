import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '/features/university/domain/entities/university.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/widgets/custom_header_layout.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class UniversityLocationPage extends ConsumerStatefulWidget {
  const UniversityLocationPage({super.key});

  @override
  ConsumerState<UniversityLocationPage> createState() =>
      _UniversityLocationPageState();
}

class _UniversityLocationPageState
    extends ConsumerState<UniversityLocationPage> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final universityAsync = ref.watch(myUniversityProvider);
    final theme = Theme.of(context);

    return universityAsync.when(
      data: (university) => CustomHeaderLayout(
        title: 'Campus Map',
        showSearchBar: false,
        body: Column(
          children: [
            // Map
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        university.latitude,
                        university.longitude,
                      ),
                      initialZoom: 15,
                      minZoom: 5,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.campusassistant.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 200,
                            height: 60,
                            point: LatLng(
                              university.latitude,
                              university.longitude,
                            ),
                            child: Column(
                              mainAxisSize: .min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.md,
                                    vertical: Spacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(
                                      RadiusToken.sm,
                                    ),
                                  ),
                                  child: Text(
                                    university.name,
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                    style: TextStyle(
                                      color: context.colors.onPrimary,
                                      fontSize: FontSizeToken.sm,
                                      fontWeight: .w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Spacing.xxs),
                                Icon(
                                  Icons.location_on,
                                  color: context.colors.danger,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Zoom controls
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        _ZoomButton(
                          icon: LucideIcons.plus,
                          onTap: () => _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        _ZoomButton(
                          icon: LucideIcons.minus,
                          onTap: () => _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom info card
            Container(
              padding: const EdgeInsets.all(Spacing.xl),
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: .stretch,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      university.name,
                      textAlign: .center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      university.address,
                      textAlign: .center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: _CoordChip(
                            label: 'Latitude',
                            value: university.latitude.toString(),
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: _CoordChip(
                            label: 'Longitude',
                            value: university.longitude.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),
                    ElevatedButton.icon(
                      onPressed: () => _openMap(university),
                      icon: const Icon(LucideIcons.navigation),
                      label: const Text('Open in Google Maps'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Campus Map'), centerTitle: true),
        body: const Center(child: CupertinoActivityIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Campus Map'), centerTitle: true),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _openMap(University uni) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${uni.latitude},${uni.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      elevation: 4,
      borderRadius: BorderRadius.circular(RadiusToken.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusToken.md),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

class _CoordChip extends StatelessWidget {
  final String label;
  final String value;

  const _CoordChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.md,
        horizontal: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: .w600),
          ),
        ],
      ),
    );
  }
}
