import 'package:flutter/material.dart';

class LevelsCompletedScreen extends StatelessWidget {
  const LevelsCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Niveles Completados')),
      body: const Center(child: Text('Completados')),
    );
  }
}