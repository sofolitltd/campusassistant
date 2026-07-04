import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_drawer.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;

    final destinations = const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.school_outlined),
        selectedIcon: Icon(Icons.school),
        label: 'Study',
      ),
      NavigationDestination(
        icon: Icon(Icons.chat_bubble_outline),
        selectedIcon: Icon(Icons.chat_bubble),
        label: 'Inbox',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    if (isLargeScreen) {
      // --- 🖥️ Large Screen Layout: NavigationRail ---
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              groupAlignment: 0,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              labelType: NavigationRailLabelType.all,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierDismissible: true,
                      barrierColor: Colors.black38,
                      pageBuilder: (_, _, _) => const CustomDrawer(),
                      transitionsBuilder: (_, anim, _, child) {
                        final offset = Tween<Offset>(
                          begin: const Offset(-1, 0), // start offscreen left
                          end: Offset.zero, // end at original position
                        ).animate(anim);

                        return SlideTransition(
                          position: offset,
                          child: Align(
                            alignment: Alignment.centerLeft, // force left side
                            child: SizedBox(
                              width: 300, // drawer width
                              child: child,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.menu),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(Icons.school),
                  label: Text('Study'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble),
                  label: Text('Inbox'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
              ],
            ),
            // const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 700),

                  child: navigationShell,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // --- 📱 Small Screen Layout: Bottom Navigation Bar ---
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 0.5),
            ),
          ),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            destinations: destinations,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      );
    }
  }
}
