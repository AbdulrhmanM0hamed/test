import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:test/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:test/features/profile/presentation/view/profile_view.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DependencyInjection.getIt.get<ProfileCubit>(),
        ),
        BlocProvider(
          create: (context) => DependencyInjection.getIt.get<AuthCubit>(),
        ),
      ],
      child: const ProfileView(),
    );
  }
}
