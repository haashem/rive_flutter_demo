import 'package:flutter/material.dart';
import 'package:rive_demo/chart/chart_page.dart';
import 'package:rive_demo/kitty_mouse_follow.dart';
import 'package:rive_demo/onboarding.dart';

enum Sample { onboarding, chart, kitty }

class ListExamplesPage extends StatelessWidget {
  const ListExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive Demo'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Onboarding'),
            onTap: () => navigateTo(context, sample: Sample.onboarding),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Chart'),
            onTap: () => navigateTo(context, sample: Sample.chart),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Kitty '),
            onTap: () => navigateTo(context, sample: Sample.kitty),
            trailing: const Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }

  void navigateTo(BuildContext context, {required Sample sample}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => switch (sample) {
              Sample.onboarding => const Onboarding(),
              Sample.chart => const ChartPage(),
              Sample.kitty => const KittyMouseFollow(),
            }));
  }
}
