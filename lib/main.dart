import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/utils/theme/app_theme.dart';
import 'package:test/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/utils/helper/on_genrated_routes.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/network/dio_service.dart';
import 'package:test/core/services/language_service.dart';
import 'package:test/core/services/country_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  await DependencyInjection.init();
  
  // Initialize CountryService
  await DependencyInjection.getIt.get<CountryService>().initialize();

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
    final initialRoute = '/splash';
    
    print(' App: Initial route determined as: $initialRoute');
    print(' App: Onboarding completed: ${appStateService.isOnboardingCompleted()}');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageService>(
          create: (context) => DependencyInjection.getIt.get<LanguageService>(),
        ),
        ChangeNotifierProvider<CountryService>(
          create: (context) => DependencyInjection.getIt.get<CountryService>(),
        ),
      ],
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            title: 'Sobieh Coffee',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: languageService.currentLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateRoute: onGenratedRoutes,
            initialRoute: initialRoute,
            builder: (context, child) {
              // Set DioService context for proper language header handling
              DioService.instance.setContext(context);
              return child!;
            },
          );
        },
      ),
    );
  }
}
