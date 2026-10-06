import 'package:flutter/material.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/section_tab_bar.dart';
import '/routes/app_route.dart';
import '/routes/scaffold_with_navbar.dart';
import '../../circular/presentation/widgets/circular_list_tab.dart';
import '../../jobs/presentation/widgets/jobs_list_tab.dart';
import '../../reminders/presentation/widgets/reminders_list_tab.dart';
import '../../reminders/presentation/widgets/set_reminder_sheet.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

class CareerPage extends ConsumerStatefulWidget {
  final int initialTab;

  const CareerPage({super.key, this.initialTab = 0});

  @override
  ConsumerState<CareerPage> createState() => _CareerPageState();
}

class _CareerPageState extends ConsumerState<CareerPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this, initialIndex: widget.initialTab)
        ..addListener(() {
          if (!_tabController.indexIsChanging) setState(() {});
        });

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget? _buildFab() {
    switch (_tabController.index) {
      case 1:
        // Lifted clear of the bottom search capsule.
        return Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: FloatingActionButton.extended(
            onPressed: () => context.pushNamed(AppRoute.careerJobCreate.name),
            icon: const Icon(Icons.add),
            label: const Text('Add job'),
          ),
        );
      case 2:
        return FloatingActionButton.extended(
          onPressed: () => showSetReminderSheet(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Add reminder'),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: _buildFab(),
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Career',
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
              padding: const EdgeInsets.only(right: Spacing.md),
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
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(RadiusToken.xxxl),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.lg,
                        Spacing.lg,
                        Spacing.lg,
                        Spacing.sm,
                      ),
                      child: SectionTabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Circular'),
                          Tab(text: 'My Jobs'),
                          Tab(text: 'Reminders'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          CircularListTab(),
                          JobsListTab(),
                          RemindersListTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
