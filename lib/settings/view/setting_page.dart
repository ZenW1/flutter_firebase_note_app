import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  static String routePath = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Setting Page'),
      ),
    );
  }
}
