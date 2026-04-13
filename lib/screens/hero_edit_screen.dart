import 'package:flutter/material.dart';

class HeroEditScreen extends StatelessWidget {
  const HeroEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Héroe')),
      body: const Center(child: Text('Formulario de Héroe')),
    );
  }
}