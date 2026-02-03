import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';

/// Provider for the router that reacts to onboarding state
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter(ref);
});

/// App router configuration using go_router
class AppRouter {
  AppRouter._();

  /// Navigator key for accessing context outside of widget tree
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Create router with ref for watching providers
  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/onboarding',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        // Check if onboarding is complete
        final onboardingState = ref.read(onboardingProvider);
        final isOnboardingComplete = onboardingState.isCompleted;
        final isLoading = onboardingState.isLoading;
        
        // Wait for loading to complete
        if (isLoading) {
          return null;
        }
        
        final isOnOnboarding = state.matchedLocation == '/onboarding';
        
        // If onboarding is complete and user is on onboarding page, redirect to home
        if (isOnboardingComplete && isOnOnboarding) {
          return '/';
        }
        
        // If onboarding is not complete and user is not on onboarding, redirect to onboarding
        if (!isOnboardingComplete && !isOnOnboarding) {
          return '/onboarding';
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Legacy static router (for backwards compatibility)
  static GoRouter get router => GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
