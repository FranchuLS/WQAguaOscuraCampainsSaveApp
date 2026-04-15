import 'package:flutter/material.dart';
import '../models/campaign_hero.dart';
import '../models/hero_equipment.dart';
import '../models/hero_reward.dart';
import '../models/hero_skill.dart';
import '../services/campaign_hero_repository.dart';
import '../services/hero_wound_service.dart';

class HeroDetailDialog extends StatefulWidget {
  final CampaignHero hero;

  const HeroDetailDialog({super.key, required this.hero});

  @override
  State<HeroDetailDialog> createState() => _HeroDetailDialogState();
}

class _HeroDetailDialogState extends State<HeroDetailDialog> {
  final CampaignHeroRepository _repository = CampaignHeroRepository();
  final HeroWoundService _woundService = HeroWoundService();

  late CampaignHero _hero;

  @override
  void initState() {
    super.initState();
    _hero = widget.hero;
  }

  String get _stateLabel {
    switch (_hero.currentState) {
      case HeroState.ok:
        return 'OK';
      case HeroState.vulnerable:
        return 'Vulnerable';
    }
  }

  Future<void> _saveHero() async {
    await _repository.saveHero(_hero);
  }

  Future<void> _applyDamage() async {
    setState(() {
      _hero = _woundService.damage(_hero);
    });
    await _saveHero();
  }

  Future<void> _applyHeal() async {
    setState(() {
      _hero = _woundService.heal(_hero);
    });
    await _saveHero();
  }

  Future<void> _addReward() async {
    final controller = TextEditingController();
    String rarity = 'Común';

    final result = await showDialog<HeroReward>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setInnerState) => AlertDialog(
          backgroundColor: const Color(0xFF16211C),
          title: const Text(
            'Añadir recompensa',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: rarity,
                dropdownColor: const Color(0xFF24362C),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF24362C),
                ),
                items: const [
                  DropdownMenuItem(value: 'Común', child: Text('Común')),
                  DropdownMenuItem(
                    value: 'Infrecuente',
                    child: Text('Infrecuente'),
                  ),
                  DropdownMenuItem(value: 'Rara', child: Text('Rara')),
                  DropdownMenuItem(value: 'Épica', child: Text('Épica')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setInnerState(() {
                    rarity = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Nombre de la recompensa',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF24362C),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                Navigator.pop(
                  context,
                  HeroReward(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    rarity: rarity,
                    name: name,
                  ),
                );
              },
              child: const Text('Añadir'),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      _hero = _hero.copyWith(rewards: [..._hero.rewards, result]);
    });

    await _saveHero();
  }

  Future<void> _addEquipment() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16211C),
        title: const Text(
          'Añadir equipo',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nombre del equipo',
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Color(0xFF24362C),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context, name);
            },
            child: const Text('Añadir'),
          ),
        ],
      ),
    );

    if (result == null) return;

    setState(() {
      _hero = _hero.copyWith(
        equipment: [
          ..._hero.equipment,
          HeroEquipment(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: result,
          ),
        ],
      );
    });

    await _saveHero();
  }

  Future<void> _addSkill() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16211C),
        title: const Text(
          'Añadir habilidad',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nombre de la habilidad',
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Color(0xFF24362C),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context, name);
            },
            child: const Text('Añadir'),
          ),
        ],
      ),
    );

    if (result == null) return;

    setState(() {
      _hero = _hero.copyWith(
        skills: [
          ..._hero.skills,
          HeroSkill(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            name: result,
            cost: 1,
          ),
        ],
      );
    });

    await _saveHero();
  }

  Future<void> _addStatus() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16211C),
        title: const Text(
          'Añadir estado',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Ej: Corrompido',
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Color(0xFF24362C),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isEmpty) return;
              Navigator.pop(context, value);
            },
            child: const Text('Añadir'),
          ),
        ],
      ),
    );

    if (result == null) return;

    setState(() {
      _hero = _hero.copyWith(statuses: [..._hero.statuses, result]);
    });

    await _saveHero();
  }

  Widget _buildTagList(List<String> values) {
    if (values.isEmpty) {
      return const Text('Ninguno', style: TextStyle(color: Colors.white70));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(value, style: const TextStyle(color: Colors.white)),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/exterior_a.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.55)),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _hero.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Estado: $_stateLabel',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Heridas: ${_hero.currentWounds}/${_hero.maxWounds}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: _applyDamage,
                              child: const Text('Quitar 1 herida'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: _applyHeal,
                              child: const Text('Añadir 1 herida'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Equipo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTagList(
                        _hero.equipment.map((item) => item.name).toList(),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _addEquipment,
                        child: const Text('Añadir equipo'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Habilidades',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTagList(
                        _hero.skills
                            .map((item) => '${item.name} (${item.cost})')
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _addSkill,
                        child: const Text('Añadir habilidad'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Recompensas',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTagList(
                        _hero.rewards
                            .map((item) => '${item.rarity}: ${item.name}')
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _addReward,
                        child: const Text('Añadir recompensa'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Estados',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTagList(_hero.statuses),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _addStatus,
                        child: const Text('Añadir estado'),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
