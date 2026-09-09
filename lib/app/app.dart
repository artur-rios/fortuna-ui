/// The application widget: theme, localization, and the router.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/format/supported_locales.dart';
import '../features/preferences/state/preferences_controller.dart';
import 'router.dart';
import 'theme.dart';

class FortunaApp extends ConsumerWidget {
  const FortunaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final preferences = ref.watch(preferencesProvider);

    return MaterialApp.router(
      title: 'Fortuna',
      debugShowCheckedModeBanner: false,
      theme: FortunaTheme.light,
      darkTheme: FortunaTheme.dark,
      themeMode: preferences.themeMode,
      supportedLocales: SupportedLocales.all,
      // The chosen locale wins; resolution is only the fallback for a first run
      // where nothing has been chosen yet (AF-01).
      locale: preferences.locale,
      localeListResolutionCallback: SupportedLocales.resolve,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
