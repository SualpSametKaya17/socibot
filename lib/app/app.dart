import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/domain/settings_preferences.dart';
import 'router/app_router.dart';
import 'theme/app_scroll_behavior.dart';
import 'theme/app_theme.dart';

class SocibotApp extends ConsumerWidget {
  const SocibotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themePreference = ref.watch(savedWorkspaceDraftProvider).theme;
    final themeMode = switch (themePreference) {
      ThemePreference.system => ThemeMode.system,
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
    };

    return MaterialApp.router(
      title: 'Socibot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Driven by the Workspace settings page's Appearance control
      // (savedWorkspaceDraftProvider.theme) — defaults to light, matching
      // the product's visual identity, but a user can opt into dark or
      // following the OS setting.
      themeMode: themeMode,
      scrollBehavior: AppScrollBehavior(),
      routerConfig: router,
    );
  }
}
