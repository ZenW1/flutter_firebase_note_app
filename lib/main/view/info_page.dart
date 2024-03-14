import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final String info;
  const InfoPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: Center(
        child: Text(info),
      ),
    );
  }
}
