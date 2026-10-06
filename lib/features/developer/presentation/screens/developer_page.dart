import 'package:flutter/foundation.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/utils/constants.dart';
import '/widgets/open_app.dart';
import '/routes/scaffold_with_navbar.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class DeveloperPage extends ConsumerWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Developer',
            style: TextStyle(
              fontWeight: .bold,
              color: context.colors.onPrimary,
              fontSize: FontSizeToken.xxl,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: Spacing.sm),
              child: GestureDetector(
                onTap: () =>
                    ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: context.colors.surface.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(Spacing.xs),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusToken.lg),
                    child: Image.asset('assets/images/logo.png', fit: .contain),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(RadiusToken.xxxl),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xxl),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // ── Developer Profile ──
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.all(Spacing.sm),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pink.shade100,
                              image: const DecorationImage(
                                fit: .cover,
                                image: AssetImage('assets/images/reyad.jpg'),
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Text(
                            kDeveloperName,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontWeight: .bold),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            'App Developer | UI/UX Designer',
                            style: TextStyle(
                              fontSize: FontSizeToken.base,
                              color: context.colors.textMuted,
                            ),
                          ),
                          const SizedBox(height: Spacing.md),
                          Row(
                            mainAxisAlignment: .center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.xs,
                                  ),
                                  color: context.colors.warning,
                                ),
                                child: Text(
                                  kDeveloperBatch,
                                  style: TextStyle(
                                    fontSize: FontSizeToken.sm,
                                    fontWeight: .w500,
                                    color: context.colors.text,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.md,
                                  vertical: Spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    RadiusToken.xs,
                                  ),
                                  color: context.colors.info,
                                ),
                                child: Text(
                                  kDeveloperSession,
                                  style: TextStyle(
                                    fontSize: FontSizeToken.sm,
                                    fontWeight: .w500,
                                    color: context.colors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            'Department of Psychology',
                            style: TextStyle(
                              fontSize: FontSizeToken.md,
                              color: context.colors.textMuted,
                            ),
                          ),
                          const SizedBox(height: Spacing.xxs),
                          Text(
                            'University of Chittagong',
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Row(
                            mainAxisAlignment: .center,
                            children: [
                              MaterialButton(
                                onPressed: () =>
                                    OpenApp.withNumber(kDeveloperMobile),
                                minWidth: 32,
                                elevation: 2,
                                color: context.colors.success,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
                                child: Icon(
                                  LucideIcons.phone,
                                  color: context.colors.onPrimary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              MaterialButton(
                                onPressed: () => OpenApp.withEmail(kAppEmail),
                                minWidth: 32,
                                elevation: 2,
                                color: context.colors.danger,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
                                child: Icon(
                                  LucideIcons.mail,
                                  color: context.colors.onPrimary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: Spacing.md),
                              MaterialButton(
                                onPressed: () => OpenApp.withUrl(kDeveloperFb),
                                minWidth: 32,
                                elevation: 2,
                                color: context.colors.info,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
                                child: Icon(
                                  LucideIcons.link,
                                  color: context.colors.onPrimary,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.xxl),

                    // ── About the App ──
                    Text(
                      'About the app',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      'Campus Assistant is a comprehensive campus management platform '
                      'built to connect students, teachers, and departments in a single '
                      'ecosystem. From study materials and class routines to club '
                      'management and event notifications, the app simplifies every '
                      'aspect of university life.',
                      style: TextStyle(
                        fontSize: FontSizeToken.base,
                        height: 1.6,
                        color: context.colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      'Developed with ❤️ by Md Asifuzzaman Reyad, Campus Assistant '
                      'started as a small departmental project and has grown into a '
                      'full-featured platform serving multiple universities. The app '
                      'continues to evolve with new features and improvements based on '
                      'student and faculty feedback.',
                      style: TextStyle(
                        fontSize: FontSizeToken.base,
                        height: 1.6,
                        color: context.colors.textMuted,
                      ),
                    ),

                    const SizedBox(height: Spacing.xxl),

                    // ── Development Team ──
                    Text(
                      'Development team',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceAlt,
                        borderRadius: BorderRadius.circular(RadiusToken.lg),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            kDevLogo,
                            height: 40,
                            errorBuilder: (_, _, _) => Text(
                              'Sofolit',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: .bold),
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                          Text(
                            'Sofolit Ltd.',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: .bold),
                          ),
                          const SizedBox(height: Spacing.xs),
                          const Text(
                            'Software & IT Solutions',
                            style: TextStyle(fontSize: FontSizeToken.md),
                          ),
                          const SizedBox(height: Spacing.md),
                          Row(
                            mainAxisAlignment: .center,
                            children: [
                              _IconChip(
                                icon: LucideIcons.globe,
                                onTap: () => OpenApp.withUrl(kDevWebsite),
                                color: context.colors.info,
                              ),
                              const SizedBox(width: Spacing.sm),
                              _IconChip(
                                icon: LucideIcons.mail,
                                onTap: () => OpenApp.withEmail(kDevEmail),
                                color: context.colors.danger,
                              ),
                              const SizedBox(width: Spacing.sm),
                              _IconChip(
                                icon: LucideIcons.video,
                                onTap: () => OpenApp.withUrl(kDevYoutube),
                                color: context.colors.danger,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.xxl),

                    // ── Links ──
                    Text(
                      'Links',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.md),
                    _LinkTile(
                      icon: LucideIcons.link,
                      iconColor: context.colors.info,
                      label: 'Facebook Page',
                      onTap: () => OpenApp.withUrl(kFbGroup),
                      isDark: isDark,
                    ),
                    const SizedBox(height: Spacing.sm),
                    _LinkTile(
                      icon: LucideIcons.link,
                      iconColor: context.colors.danger,
                      label: 'YouTube Channel',
                      onTap: () => OpenApp.withUrl(kYoutubeUrl),
                      isDark: isDark,
                    ),
                    const SizedBox(height: Spacing.sm),
                    _LinkTile(
                      icon: LucideIcons.star,
                      iconColor: context.colors.warning,
                      label: 'Rate on PlayStore',
                      onTap: () => OpenApp.withUrl(kPlayStoreUrl),
                      isDark: isDark,
                    ),
                    const SizedBox(height: Spacing.sm),
                    _LinkTile(
                      icon: LucideIcons.globe,
                      iconColor: context.colors.primary,
                      label: 'Visit Website',
                      onTap: () => OpenApp.withUrl(kDevWebsite),
                      isDark: isDark,
                    ),

                    const SizedBox(height: Spacing.sm),

                    // ── Contributors button ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/contributors'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(RadiusToken.lg),
                          ),
                        ),
                        child: const Text('Our Contributors'),
                      ),
                    ),

                    const SizedBox(height: Spacing.xxxl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _IconChip({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      minWidth: 32,
      elevation: 1,
      color: color.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(Spacing.md),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _LinkTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusToken.md),
        border: Border.all(color: context.colors.border),
      ),
      child: ListTile(
        onTap: onTap,
        visualDensity: VisualDensity.compact,
        leading: Icon(icon, color: iconColor, size: 20),
        title: Text(
          label,
          style: const TextStyle(fontSize: FontSizeToken.base),
        ),
        trailing: Icon(
          LucideIcons.chevronRight,
          size: 16,
          color: context.colors.textSubtle,
        ),
      ),
    );
  }
}
