import 'package:flutter/material.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/auth/presentation/view/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await DependencyInjection.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      routes: {
        LoginView.routeName: (context) => const LoginView(),
        // other routes...
      },
      home: const LoginView(), // or your initial screen
    );
  }
}
