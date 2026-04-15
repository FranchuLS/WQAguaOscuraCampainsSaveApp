import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/hero_repository.dart';
import '../widgets/app_background.dart';

class HeroEditScreen extends StatefulWidget {
  final String campaignId;
  final HeroModel? hero;

  const HeroEditScreen({super.key, required this.campaignId, this.hero});

  @override
  State<HeroEditScreen> createState() => _HeroEditScreenState();
}

class _HeroEditScreenState extends State<HeroEditScreen> {
  final HeroRepository _heroRepository = HeroRepository();

  late final TextEditingController _nameController;
  late final TextEditingController _woundsController;

  late HeroStatus _selectedStatus;

  bool get _isEditing => widget.hero != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hero?.name ?? '');
    _woundsController = TextEditingController(
      text: (widget.hero?.wounds ?? 0).toString(),
    );
    _selectedStatus = widget.hero?.status ?? HeroStatus.ok;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _woundsController.dispose();
    super.dispose();
  }

  Future<void> _saveHero() async {
    final name = _nameController.text.trim();
    final wounds = int.tryParse(_woundsController.text.trim()) ?? 0;

    if (name.isEmpty) {
      return;
    }

    final hero = HeroModel(
      id: widget.hero?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      campaignId: widget.campaignId,
      name: name,
      status: _selectedStatus,
      wounds: wounds,
    );

    await _heroRepository.saveHero(hero);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar héroe' : 'Nuevo héroe'),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.35),
      ),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF1A1F26),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nombre del héroe',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF24362C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Estado',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<HeroStatus>(
                    initialValue: _selectedStatus,
                    dropdownColor: const Color(0xFF24362C),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF24362C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: HeroStatus.ok, child: Text('OK')),
                      DropdownMenuItem(
                        value: HeroStatus.vulnerable,
                        child: Text('Vulnerable'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Heridas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _woundsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Número de heridas',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF24362C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7ED9A3),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _saveHero,
              child: Text(
                _isEditing ? 'Guardar cambios' : 'Crear héroe',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
