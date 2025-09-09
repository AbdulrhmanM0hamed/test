import 'package:flutter/material.dart';
import 'package:test/features/home/presentation/widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomePageBody(),
    );
  }
}
