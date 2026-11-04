import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healora/core/services/healora_state.dart';
import 'package:healora/core/theme/healora_theme.dart';
import 'package:healora/core/theme/healora_colors.dart';
import 'package:healora/core/theme/healora_spacing.dart';
import 'package:healora/core/common/widgets/healora_header.dart';
import 'package:healora/core/common/widgets/healora_sidebar.dart';
import 'package:healora/features/dashboard/controllers/dashboard_controller.dart';
import 'package:healora/features/equipment/controllers/equipment_controller.dart';
import 'package:healora/features/sessions/controllers/sessions_controller.dart';
import 'package:healora/routes/app_routes.dart';

class HealoraApp extends StatefulWidget {
  const HealoraApp({super.key});

  @override
  State<HealoraApp> createState() => _HealoraAppState();
}

class _HealoraAppState extends State<HealoraApp> {
  final HealoraState _state = HealoraState();

  @override
  void dispose() {
    if (Get.isRegistered<DashboardController>()) {
      Get.delete<DashboardController>();
    }
    if (Get.isRegistered<SessionsController>()) {
      Get.delete<SessionsController>();
    }
    if (Get.isRegistered<EquipmentController>()) {
      Get.delete<EquipmentController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HealoraState>(
      init: _state,
      builder: (state) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          title: 'Healora · Hub Management & Clinical Care Platform',
          debugShowCheckedModeBanner: false,
          theme: HealoraTheme.lightTheme,
          home: HealoraShell(state: state),
        );
      },
    );
  }
}

class HealoraShell extends StatelessWidget {
  final HealoraState state;

  const HealoraShell({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isDesktop = width >= HealoraSpacing.bpDesktop; // >= 1100px
        final bool isTablet =
            width >= HealoraSpacing.bpTablet &&
            width < HealoraSpacing.bpDesktop; // 600 - 1099px
        final bool isMobile = width < HealoraSpacing.bpTablet; // < 600px

        return Scaffold(
          backgroundColor: HealoraColors.bone,
          body: Column(
            children: [
              // Global Header
              HealoraHeader(state: state, isDesktop: isDesktop || isTablet),

              // Offline notification bar (Pinned under header when offline, Chapter 7.9)
              if (state.isOffline)
                Container(
                  height: 36,
                  color: HealoraColors.warnBg,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wifi_off,
                        size: 16,
                        color: HealoraColors.warnFg,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.t(
                          'You\'re offline. Rural Mode active. Local data is encrypted; changes will auto-sync upon reconnection.',
                          'আপনি অফলাইনে আছেন। গ্রামীণ মোড সক্রিয়। ডেটা স্থানীয়ভাবে সুরক্ষিত এবং নেটওয়ার্ক ফিরলে সমলয় হবে।',
                        ),
                        style: TextStyle(
                          color: HealoraColors.warnFg,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (state.offlineOutbox.isNotEmpty)
                        Text(
                          state.t(
                            'Pending outbox items: ${state.offlineOutbox.length}',
                            'অপেক্ষমাণ আইটেম: ${state.offlineOutbox.length}',
                          ),
                          style: TextStyle(
                            color: HealoraColors.warnFg,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),

              // Main Body with Sidebar/Navigation and View
              Expanded(
                child: Stack(
                  children: [
                    Row(
                      children: [
                        // Left Sidebar (Desktop 248px, Tablet 88px)
                        if (!isMobile)
                          HealoraSidebar(state: state, isTablet: isTablet),

                        // Main Content View Area
                        Expanded(
                          child: Container(
                            color: HealoraColors.bone,
                            child: _buildCurrentView(state),
                          ),
                        ),
                      ],
                    ),

                    // Floating Tab Bar for Mobile (Chapter 05 & 7.8)
                    if (isMobile) HealoraFloatingTabBar(state: state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentView(HealoraState state) {
    return AppRoutes.pageForIndex(state.currentNavIndex, state);
  }
}
