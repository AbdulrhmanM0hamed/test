import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:test/features/home/presentation/widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (context) => DependencyInjection.getIt<NotificationsCubit>()
        ..getNotifications(),
      child: Scaffold(body: const HomePageBody()),
    );
  }
}
