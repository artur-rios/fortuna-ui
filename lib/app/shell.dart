/// Screens the foundation itself owns: the not-found screen the router falls
/// back to, and the placeholder each route carries until its use case builds
/// the real one.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

/// Shown for a route that does not exist (`UC-46 AF-05`).
///
/// Deliberately rendered inside the application's own chrome rather than as a
/// blank page: a user who mistypes a URL should land somewhere they can get out
/// of.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({required this.location, super.key});

  final String location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No screen at $location',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The address may be out of date.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(Routes.home),
                child: const Text('Go to the overview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A route that exists and is guarded, but whose screen belongs to a use case
/// that has not been implemented yet.
///
/// It names that use case rather than showing a blank page, so that running the
/// application mid-backlog says what is missing instead of looking broken.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    required this.route,
    required this.implementedBy,
    super.key,
  });

  final String title;
  final String route;
  final String implementedBy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                '$route is routed and guarded. Its screen is $implementedBy.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
