import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qms_mobile/config/themes.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/providers/auth_provider.dart';
import 'package:qms_mobile/data/providers/language_provider.dart';
import 'package:qms_mobile/data/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/auth_service.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/utils/helpers/error_loger.dart';
import 'package:qms_mobile/views/screens/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.dumpErrorToConsole(details);
    await ErrorLogger.logError(
        details.toString()); // Logging synchronous errors
  };

  runZonedGuarded(() {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) async {
    await ErrorLogger.logError(
        '$error\n$stackTrace'); // Logging asynchronous errors
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(languageProvider);

    return MaterialApp(
      navigatorKey: navigationService.navigatorKey,
      title: 'QMS',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode, // Theme mode from provider
      home: ProviderScope(
        overrides: [
          authServiceProvider
              .overrideWithValue(AuthService(ref.read(apiServiceProvider))),
        ],
        child: const LoginScreen(),
      ),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.getRoutes(),
    );
  }
}
