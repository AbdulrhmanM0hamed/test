import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/auth/presentation/view/login_view.dart';

class LoginWrapper extends StatelessWidget {
  static const String routeName = '/login-wrapper';

  const LoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DependencyInjection.createAuthCubit(),
      child: const LoginView(),
    );
  }
}
