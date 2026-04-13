import 'package:flutter/material.dart';

class LevelsAllScreen extends StatelessWidget {
  const LevelsAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos los Niveles')),
      body: const Center(child: Text('Todos los niveles')),
    );
  }
}