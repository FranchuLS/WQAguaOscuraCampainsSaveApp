import 'package:flutter/material.dart';

import '../models/campaign.dart';
import '../models/campaign_hero.dart';
import '../services/campaign_hero_repository.dart';
import '../widgets/action_button_tile.dart';
import '../widgets/section_card.dart';
import 'hero_detail_dialog.dart';

class CampaignDetailScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final CampaignHeroRepository _heroRepository = CampaignHeroRepository();

  List<CampaignHero> _heroes = [];
  bool _isLoadingHeroes = true;

  bool get _canAdvanceAct => widget.campaign.pendingLevelsCount == 0;

  @override
  void initState() {
    super.initState();
    _loadHeroes();
  }

  Future<void> _loadHeroes() async {
    final heroes = _heroRepository.getHeroesByCampaign(widget.campaign.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _heroes = heroes;
      _isLoadingHeroes = false;
    });
  }

  Future<void> _openHeroDialog(CampaignHero hero) async {
    await showDialog<void>(
      context: context,
      builder: (context) => HeroDetailDialog(hero: hero),
    );

    await _loadHeroes();
  }

  void _showNotImplementedMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAddHeroUnavailableDialog() {
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
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.name),
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
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _InfoPill(
                            icon: Icons.flag_rounded,
                            label: 'Acto ${campaign.currentAct}',
                          ),
                          _InfoPill(
                            icon: Icons.groups_rounded,
                            label: '${_heroes.length} héroes',
                          ),
                          _InfoPill(
                            icon: Icons.map_rounded,
                            label: '${campaign.pendingLevelsCount} pendientes',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mapas pendientes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (campaign.pendingLevelsCount == 0)
                        const Text(
                          'No hay mapas pendientes.',
                          style: TextStyle(color: Colors.white70),
                        )
                      else
                        Column(
                          children: List.generate(
                            campaign.pendingLevelsCount,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PendingLevelTile(
                                text: 'Mapa pendiente ${index + 1}',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Héroes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_isLoadingHeroes)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_heroes.isEmpty)
                        const Text(
                          'No hay héroes añadidos todavía.',
                          style: TextStyle(color: Colors.white70),
                        )
                      else
                        Column(
                          children: _heroes
                              .map(
                                (hero) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _CampaignHeroTile(
                                    hero: hero,
                                    onTap: () => _openHeroDialog(hero),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    children: [
                      ActionButtonTile(
                        icon: Icons.person_add_alt_1_rounded,
                        label: 'Añadir héroe',
                        onTap: _showAddHeroUnavailableDialog,
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.alt_route_rounded,
                        label: 'Ver siguientes niveles',
                        onTap: () {
                          _showNotImplementedMessage('Ver siguientes niveles');
                        },
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.task_alt_rounded,
                        label: 'Ver niveles superados',
                        onTap: () {
                          _showNotImplementedMessage('Ver niveles superados');
                        },
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.block_rounded,
                        label: 'Ver niveles descartados',
                        onTap: () {
                          _showNotImplementedMessage('Ver niveles descartados');
                        },
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.library_books_rounded,
                        label: 'Ver todos los niveles',
                        onTap: () {
                          _showNotImplementedMessage('Ver todos los niveles');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_canAdvanceAct)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7ED9A3),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      _showNotImplementedMessage('Pasar de acto');
                    },
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text(
                      'Pasar de acto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: const Color(0xFFA7E3BE)),
          const SizedBox(width: 7),
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

class _PendingLevelTile extends StatelessWidget {
  final String text;

  const _PendingLevelTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF2D2234),
      ),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _CampaignHeroTile extends StatelessWidget {
  final CampaignHero hero;
  final VoidCallback onTap;

  const _CampaignHeroTile({required this.hero, required this.onTap});

  String get _stateLabel {
    switch (hero.currentState) {
      case HeroState.ok:
        return 'OK';
      case HeroState.vulnerable:
        return 'Vulnerable';
    }
  }

  String get _statusesLabel {
    if (hero.statuses.isEmpty) {
      return 'Sin estados';
    }

    return hero.statuses.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFF1F2E2A),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withValues(alpha: 0.25),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estado: $_stateLabel · Heridas: ${hero.currentWounds}/${hero.maxWounds}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _statusesLabel,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
