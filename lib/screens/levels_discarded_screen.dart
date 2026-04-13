import 'package:flutter/material.dart';

class LevelsDiscardedScreen extends StatelessWidget {
  const LevelsDiscardedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Niveles Descartados')),
      body: const Center(child: Text('Descartados')),
    );
  }
}