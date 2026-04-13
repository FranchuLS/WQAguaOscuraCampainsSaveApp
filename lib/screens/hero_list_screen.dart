import 'package:flutter/material.dart';

class HeroListScreen extends StatelessWidget {
  const HeroListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Héroes')),
      body: const Center(child: Text('Lista de Héroes')),
    );
  }
}