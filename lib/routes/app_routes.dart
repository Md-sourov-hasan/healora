import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healora/features/bottom_navigation/screens/bottom_navigation_screen.dart';
import 'package:healora/features/home/presentation/screens/home_screen.dart';
import 'package:healora/features/hubs/presentation/screens/hubs_find_screen.dart';
import 'package:healora/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:healora/features/checkin/presentation/screens/checkin_patient_screen.dart';
import 'package:healora/features/consent/presentation/screens/consent_screen.dart';
import 'package:healora/features/results/presentation/screens/results_screen.dart';
import 'package:healora/features/follow_ups/presentation/screens/follow_ups_screen.dart';
import 'package:healora/features/notifications/presentation/screens/patient_notifications_screen.dart';
import 'package:healora/features/profile/presentation/screens/profile_screen.dart';

class AppRoute {
  // ---------------------------------------------------------------------------
  // Route Constants matching PRD Specification
  // ---------------------------------------------------------------------------
  static const String initial = "/";
  static const String home = "/home";
  static const String hubs = "/hubs";
  static const String bookings = "/bookings";
  static const String checkIn = "/check-in";
  static const String consent = "/consent";
  static const String results = "/results";
  static const String followUps = "/follow-ups";
  static const String notifications = "/notifications";
  static const String profile = "/profile";

  // ---------------------------------------------------------------------------
  // Global Navigator Keys
  // ---------------------------------------------------------------------------
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  // Shell tabs that should be navigated via context.go to prevent duplicate keys
  static const Set<String> shellTabs = {
    home,
    hubs,
    bookings,
    results,
    profile,
  };

  static void navigate(BuildContext context, String path) {
    if (shellTabs.contains(path)) {
      context.go(path);
    } else {
      context.push(path);
    }
  }

  // ---------------------------------------------------------------------------
  // Custom Page Transition
  // ---------------------------------------------------------------------------
  static CustomTransitionPage<void> _buildPageWithTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    bool slideUp = false,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = slideUp ? const Offset(0.0, 0.1) : const Offset(0.05, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // GoRouter Configuration
  // ---------------------------------------------------------------------------
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: home,
    routes: [
      GoRoute(
        path: initial,
        redirect: (context, state) => home,
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) =>
            BottomNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => _buildPageWithTransition(
              context: context,
              state: state,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: hubs,
            pageBuilder: (context, state) => _buildPageWithTransition(
              context: context,
              state: state,
              child: const HubsFindScreen(),
            ),
          ),
          GoRoute(
            path: bookings,
            pageBuilder: (context, state) => _buildPageWithTransition(
              context: context,
              state: state,
              child: const BookingsScreen(),
            ),
          ),
          GoRoute(
            path: results,
            pageBuilder: (context, state) => _buildPageWithTransition(
              context: context,
              state: state,
              child: const ResultsScreen(),
            ),
          ),
          GoRoute(
            path: profile,
            pageBuilder: (context, state) => _buildPageWithTransition(
              context: context,
              state: state,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: checkIn,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const CheckInPatientScreen(),
          slideUp: true,
        ),
      ),
      GoRoute(
        path: consent,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const ConsentScreen(),
          slideUp: true,
        ),
      ),
      GoRoute(
        path: followUps,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const FollowUpsScreen(),
          slideUp: true,
        ),
      ),
      GoRoute(
        path: notifications,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const PatientNotificationsScreen(),
          slideUp: true,
        ),
      ),
    ],
  );
}
