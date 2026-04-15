import 'package:flutter/material.dart';

import '../models/campaign.dart';
import '../models/campaign_hero.dart';
import '../services/campaign_hero_repository.dart';
import '../widgets/action_button_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/info_pill.dart';
import '../widgets/pending_level_tile.dart';
import '../widgets/campaign_hero_tile.dart';
import '../widgets/app_background.dart';
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
      appBar: _buildAppBar(campaign),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCampaignHeader(campaign),
              const SizedBox(height: 16),
              _buildPendingLevelsSection(campaign),
              const SizedBox(height: 16),
              _buildHeroesSection(),
              const SizedBox(height: 16),
              _buildActionsSection(),
              const SizedBox(height: 20),
              if (_canAdvanceAct) _buildAdvanceActButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(Campaign campaign) {
    return AppBar(
      title: Text(campaign.name),
      centerTitle: true,
      backgroundColor: Colors.black.withValues(alpha: 0.35),
    );
  }

  Widget _buildCampaignHeader(Campaign campaign) {
    return SectionCard(
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
              InfoPill(
                icon: Icons.flag_rounded,
                label: 'Acto ${campaign.currentAct}',
              ),
              InfoPill(icon: Icons.groups_rounded, label: '${_heroes.length} héroes'),
              InfoPill(
                icon: Icons.map_rounded,
                label: '${campaign.pendingLevelsCount} pendientes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingLevelsSection(Campaign campaign) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mapas pendientes',
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (campaign.pendingLevelsCount == 0)
            const Text('No hay mapas pendientes.', style: TextStyle(color: Colors.white70))
          else
            ...List.generate(
              campaign.pendingLevelsCount,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PendingLevelTile(text: 'Mapa pendiente ${index + 1}'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroesSection() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Héroes',
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
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
            ..._heroes.map(
              (hero) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CampaignHeroTile(
                  hero: hero,
                  onTap: () => _openHeroDialog(hero),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return SectionCard(
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
            onTap: () => _showNotImplementedMessage('Ver siguientes niveles'),
          ),
          const SizedBox(height: 10),
          ActionButtonTile(
            icon: Icons.task_alt_rounded,
            label: 'Ver niveles superados',
            onTap: () => _showNotImplementedMessage('Ver niveles superados'),
          ),
          const SizedBox(height: 10),
          ActionButtonTile(
            icon: Icons.block_rounded,
            label: 'Ver niveles descartados',
            onTap: () => _showNotImplementedMessage('Ver niveles descartados'),
          ),
          const SizedBox(height: 10),
          ActionButtonTile(
            icon: Icons.library_books_rounded,
            label: 'Ver todos los niveles',
            onTap: () => _showNotImplementedMessage('Ver todos los niveles'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvanceActButton() {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF7ED9A3),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => _showNotImplementedMessage('Pasar de acto'),
      icon: const Icon(Icons.auto_awesome_rounded),
      label: const Text('Pasar de acto', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
