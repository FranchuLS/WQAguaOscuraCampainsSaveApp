import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/hero_model.dart';
import '../services/hero_repository.dart';
import 'hero_edit_screen.dart';

class HeroListScreen extends StatefulWidget {
  final Campaign campaign;

  const HeroListScreen({super.key, required this.campaign});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  final HeroRepository _heroRepository = HeroRepository();

  List<HeroModel> _heroes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHeroes();
  }

  void _loadHeroes() {
    final heroes = _heroRepository.getHeroesByCampaign(widget.campaign.id);

    setState(() {
      _heroes = heroes;
      _isLoading = false;
    });
  }

  Future<void> _openEditHero(HeroModel hero) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) =>
            HeroEditScreen(campaignId: widget.campaign.id, hero: hero),
      ),
    );

    if (updated == true) {
      _loadHeroes();
    }
  }

  Future<void> _deleteHero(HeroModel hero) async {
    await _heroRepository.deleteHero(hero.id);
    _loadHeroes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Héroes'),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.35),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/luz_purpura.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_heroes.isEmpty)
            const Center(
              child: Text(
                'No hay héroes todavía',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _heroes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final hero = _heroes[index];
                return _HeroCard(
                  hero: hero,
                  onTap: () => _openEditHero(hero),
                  onDelete: () => _deleteHero(hero),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF16211C),
              title: const Text(
                'Añadir héroe',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'No tienes ningún héroe que puedas añadir.',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
        backgroundColor: const Color(0xFF6BBF8B),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Añadir héroe'),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HeroCard({
    required this.hero,
    required this.onTap,
    required this.onDelete,
  });

  String get _statusLabel {
    switch (hero.status) {
      case HeroStatus.ok:
        return 'OK';
      case HeroStatus.vulnerable:
        return 'Vulnerable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2A22), Color(0xFF355844), Color(0xFF6FA98A)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black.withValues(alpha: 0.18),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _HeroInfoChip(
                            icon: Icons.health_and_safety_rounded,
                            label: '${hero.wounds} heridas',
                          ),
                          _HeroInfoChip(
                            icon: Icons.warning_amber_rounded,
                            label: _statusLabel,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  iconColor: Colors.white,
                  color: const Color(0xFF203026),
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Borrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
