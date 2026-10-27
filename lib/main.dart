import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/localization/app_localizations.dart';
import 'core/providers/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: VidyaGuruApp(),
    ),
  );
}

class VidyaGuruApp extends ConsumerWidget {
  const VidyaGuruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currentLanguage = ref.watch(currentLanguageProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      locale: Locale(currentLanguage.code),
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
        Locale('bn', ''),
        Locale('ta', ''),
        Locale('te', ''),
        Locale('mr', ''),
        Locale('gu', ''),
        Locale('kn', ''),
        Locale('ml', ''),
        Locale('pa', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
