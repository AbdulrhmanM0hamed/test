import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/theme/app_theme.dart';
import 'package:test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/utils/helper/on_genrated_routes.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/network/dio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await DependencyInjection.init();

  // Set preferred orientations to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.1
  @override
  Widget build(BuildContext context) {
    // Get initial route based on app state
    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final initialRoute = appStateService.getInitialRoute();

    return MaterialApp(
      title: 'دكاكين',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: Locale('ar'),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      onGenerateRoute: onGenratedRoutes,
      initialRoute: initialRoute,
      builder: (context, child) {
        // Set DioService context for proper language header handling
        DioService.instance.setContext(context);
        return child!;
      },
    );
  }
}
