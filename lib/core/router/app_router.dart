import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/authentication/presentation/authentication_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/project_selection/presentation/project_selection_screen.dart';

/// Application routing configuration using GoRouter
class AppRouter {
  static const String authenticationRoute = '/auth';
  static const String projectSelectionRoute = '/projects';
  static const String dashboardRoute = '/dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: authenticationRoute,
    routes: [
      GoRoute(
        path: authenticationRoute,
        name: 'auth',
        builder: (context, state) => const AuthenticationScreen(),
      ),
      GoRoute(
        path: projectSelectionRoute,
        name: 'projectSelection',
        builder: (context, state) => const ProjectSelectionScreen(),
      ),
      GoRoute(
        path: dashboardRoute,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => const AuthenticationScreen(),
  );

  /// Navigate to authentication screen
  static void navigateToAuth(BuildContext context) {
    context.go(authenticationRoute);
  }

  /// Navigate to project selection screen
  static void navigateToProjectSelection(BuildContext context) {
    context.go(projectSelectionRoute);
  }

  /// Navigate to dashboard screen
  static void navigateToDashboard(BuildContext context) {
    context.go(dashboardRoute);
  }
}