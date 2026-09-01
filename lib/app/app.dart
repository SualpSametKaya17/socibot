import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class SocibotApp extends ConsumerWidget {
  const SocibotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Socibot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // The product's visual identity is the light SaaS look; don't let a
      // viewer's OS dark-mode setting silently switch it. Dark theme stays
      // implemented for later, just not auto-triggered yet.
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
