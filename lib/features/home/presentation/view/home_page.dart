import 'package:flutter/material.dart';
import 'package:test/generated/l10n.dart';
import 'package:test/features/home/presentation/widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).home),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(child: const HomePageBody()),
    );
  }
}
