import 'package:flutter/material.dart';

class LevelsPendingScreen extends StatelessWidget {
  const LevelsPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Niveles Pendientes')),
      body: const Center(child: Text('Pendientes')),
    );
  }
}