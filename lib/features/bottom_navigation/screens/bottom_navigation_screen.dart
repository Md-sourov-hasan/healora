import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/features/bottom_navigation/controllers/bottom_navigation_controller.dart';
import 'package:healora/features/bottom_navigation/widgets/custom_bottom_navigation.dart';

class BottomNavigationScreen extends StatelessWidget {
  final Widget child;

  const BottomNavigationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final BottomNavigationController controller = Get.put(
      BottomNavigationController(),
    );

    // Sync tab index with active location
    final String location = GoRouterState.of(context).uri.path;
    controller.setTabByRoute(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.currentIndex,
          onTabSelected: (index) {
            controller.changeTab(index);
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/hubs');
                break;
              case 2:
                context.go('/bookings');
                break;
              case 3:
                context.go('/results');
                break;
              case 4:
                context.go('/profile');
                break;
            }
          },
        ),
      ),
    );
  }
}

