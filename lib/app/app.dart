/// The application widget: theme, localization, and the router.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/format/supported_locales.dart';
import 'router.dart';
import 'theme.dart';

class FortunaApp extends ConsumerWidget {
  const FortunaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Fortuna',
      debugShowCheckedModeBanner: false,
      theme: FortunaTheme.light,
      darkTheme: FortunaTheme.dark,
      themeMode: ThemeMode.system,
      supportedLocales: SupportedLocales.all,
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
