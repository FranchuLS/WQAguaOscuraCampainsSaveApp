import 'package:flutter/material.dart';
import 'package:wqaguaoscura_app/widgets/hero_card.dart';
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
                return HeroCard(
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
