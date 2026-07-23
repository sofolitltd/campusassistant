import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/utils/constants.dart';
import '/widgets/open_app.dart';
import '/routes/scaffold_with_navbar.dart';

class DeveloperPage extends ConsumerWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).appColors.primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Developer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () =>
                  ScaffoldWithNavBar.scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
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
              top: Radius.circular(24),
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Developer Profile ──
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink.shade100,
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/reyad.jpg'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          kDeveloperName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'App Developer | UI/UX Designer',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.orange[100],
                              ),
                              child: const Text(
                                kDeveloperBatch,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.blue.shade100,
                              ),
                              child: const Text(
                                kDeveloperSession,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Department of Psychology',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'University of Chittagong',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () => OpenApp.withNumber(kDeveloperMobile),
                              minWidth: 32,
                              elevation: 2,
                              color: Colors.green,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
                              child: const Icon(
                                LucideIcons.phone,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            MaterialButton(
                              onPressed: () => OpenApp.withEmail(kAppEmail),
                              minWidth: 32,
                              elevation: 2,
                              color: Colors.red,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
                              child: const Icon(
                                LucideIcons.mail,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            MaterialButton(
                              onPressed: () => OpenApp.withUrl(kDeveloperFb),
                              minWidth: 32,
                              elevation: 2,
                              color: Colors.blue,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
                              child: const Icon(
                                LucideIcons.link,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── About the App ──
                  Text(
                    'About the App'.toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Campus Assistant is a comprehensive campus management platform '
                    'built to connect students, teachers, and departments in a single '
                    'ecosystem. From study materials and class routines to club '
                    'management and event notifications, the app simplifies every '
                    'aspect of university life.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Developed with ❤️ by Md Asifuzzaman Reyad, Campus Assistant '
                    'started as a small departmental project and has grown into a '
                    'full-featured platform serving multiple universities. The app '
                    'continues to evolve with new features and improvements based on '
                    'student and faculty feedback.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Development Team ──
                  Text(
                    'Development Team'.toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.network(
                          kDevLogo,
                          height: 40,
                          errorBuilder: (_, _, _) => Text(
                            'Sofolit',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sofolit Ltd.',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Software & IT Solutions',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _IconChip(
                              icon: LucideIcons.globe,
                              onTap: () => OpenApp.withUrl(kDevWebsite),
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            _IconChip(
                              icon: LucideIcons.mail,
                              onTap: () => OpenApp.withEmail(kDevEmail),
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            _IconChip(
                              icon: LucideIcons.video,
                              onTap: () => OpenApp.withUrl(kDevYoutube),
                              color: Colors.red.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Links ──
                  Text(
                    'Links'.toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _LinkTile(
                    icon: LucideIcons.link,
                    iconColor: Colors.blue,
                    label: 'Facebook Page',
                    onTap: () => OpenApp.withUrl(kFbGroup),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _LinkTile(
                    icon: LucideIcons.link,
                    iconColor: Colors.red,
                    label: 'YouTube Channel',
                    onTap: () => OpenApp.withUrl(kYoutubeUrl),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _LinkTile(
                    icon: LucideIcons.star,
                    iconColor: Colors.orange,
                    label: 'Rate on PlayStore',
                    onTap: () => OpenApp.withUrl(kPlayStoreUrl),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _LinkTile(
                    icon: LucideIcons.globe,
                    iconColor: Theme.of(context).appColors.primaryColor,
                    label: 'Visit Website',
                    onTap: () => OpenApp.withUrl(kDevWebsite),
                    isDark: isDark,
                  ),

                  const SizedBox(height: 8),

                  // ── Contributors button ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/contributors'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Our Contributors'),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
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
      padding: const EdgeInsets.all(10),
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        visualDensity: VisualDensity.compact,
        leading: Icon(icon, color: iconColor, size: 20),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        trailing: Icon(
          LucideIcons.chevronRight,
          size: 16,
          color: isDark ? Colors.white38 : Colors.grey.shade400,
        ),
      ),
    );
  }
}
