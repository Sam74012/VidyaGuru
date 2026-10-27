import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/app_config.dart';
import '../providers/app_providers.dart';
import '../theme/app_colors.dart';

class MainScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider);
    final isTeacher = userRole == UserRole.teacher;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          elevation: 0,
          backgroundColor: Theme.of(context).cardColor,
          indicatorColor: AppColors.primaryContainer,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.add_circle_outline_rounded),
              selectedIcon: Icon(Icons.add_circle_rounded, color: AppColors.saffronDark),
              label: 'Create',
            ),
            const NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school_rounded, color: AppColors.primary),
              label: 'Teachers',
            ),
            const NavigationDestination(
              icon: Icon(Icons.download_for_offline_outlined),
              selectedIcon: Icon(Icons.download_for_offline_rounded, color: AppColors.primary),
              label: 'Downloads',
            ),
            NavigationDestination(
              icon: Icon(isTeacher ? Icons.dashboard_outlined : Icons.settings_outlined),
              selectedIcon: Icon(
                isTeacher ? Icons.dashboard_rounded : Icons.settings_rounded,
                color: AppColors.primary,
              ),
              label: isTeacher ? 'Dashboard' : 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
