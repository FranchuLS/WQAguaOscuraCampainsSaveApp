import 'package:flutter/material.dart';

import '../models/campaign.dart';
import '../models/campaign_hero.dart';
import '../models/campaign_level.dart';
import '../services/campaign_hero_repository.dart';
import '../services/campaign_level_repository.dart';
import '../services/campaign_level_service.dart';
import '../services/campaign_repository.dart';
import '../widgets/action_button_tile.dart';
import '../widgets/app_background.dart';
import '../widgets/campaign_hero_tile.dart';
import '../widgets/info_pill.dart';
import '../widgets/pending_level_tile.dart';
import '../widgets/section_card.dart';
import 'hero_detail_dialog.dart';
import 'levels_all_screen.dart';
import 'levels_completed_screen.dart';
import 'levels_discarded_screen.dart';
import 'levels_pending_screen.dart';

class CampaignDetailScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final CampaignHeroRepository _heroRepository = CampaignHeroRepository();
  final CampaignLevelRepository _levelRepository = CampaignLevelRepository();
  final CampaignLevelService _levelService = CampaignLevelService();
  final CampaignRepository _campaignRepository = CampaignRepository();

  late Campaign _campaign;

  List<CampaignHero> _heroes = [];
  List<CampaignLevel> _currentLevels = [];

  bool _isLoadingHeroes = true;
  bool _isLoadingLevels = true;

  bool get _canAdvanceAct => _campaign.pendingLevelsCount == 0;

  @override
  void initState() {
    super.initState();
    _campaign = widget.campaign;
    _bootstrapAndRefresh();
  }

  Future<void> _bootstrapAndRefresh() async {
    _campaign = await _levelService.bootstrapActLevels(_campaign);
    await _refreshAll();
  }

  Future<void> _refreshAll() async {
    final freshCampaign = _campaignRepository.getCampaignById(_campaign.id);
    final heroes = _heroRepository.getHeroesByCampaign(_campaign.id);
    final currentLevels = _levelRepository.getCurrentRoundLevels(
      _campaign.id,
      _campaign.currentAct,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _campaign = freshCampaign ?? _campaign;
      _heroes = heroes;
      _currentLevels = currentLevels;
      _isLoadingHeroes = false;
      _isLoadingLevels = false;
    });
  }

  Future<void> _openHeroDialog(CampaignHero hero) async {
    await showDialog<void>(
      context: context,
      builder: (context) => HeroDetailDialog(hero: hero),
    );

    await _refreshAll();
  }

  Future<void> _openPendingLevels() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LevelsPendingScreen(campaign: _campaign),
      ),
    );

    await _refreshAll();
  }

  Future<void> _openCompletedLevels() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LevelsCompletedScreen(campaign: _campaign),
      ),
    );

    await _refreshAll();
  }

  Future<void> _openDiscardedLevels() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LevelsDiscardedScreen(campaign: _campaign),
      ),
    );

    await _refreshAll();
  }

  Future<void> _openAllLevels() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LevelsAllScreen(campaign: _campaign),
      ),
    );

    await _refreshAll();
  }

  Future<void> _advanceAct() async {
    final updatedCampaign = await _levelService.advanceAct(_campaign);

    if (!mounted) {
      return;
    }

    setState(() {
      _campaign = updatedCampaign;
    });

    await _refreshAll();
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

  String _typeLabel(LevelType type) {
    switch (type) {
      case LevelType.safePlace:
        return 'Lugar de descanso';
      case LevelType.encounter:
        return 'Encuentro';
      case LevelType.event:
        return 'Evento';
      case LevelType.boss:
        return 'Jefe';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCampaignHeader(),
              const SizedBox(height: 16),
              _buildPendingLevelsSection(),
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

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_campaign.name),
      centerTitle: true,
      backgroundColor: Colors.black.withValues(alpha: 0.35),
    );
  }

  Widget _buildCampaignHeader() {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _campaign.name,
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
                label: 'Acto ${_campaign.currentAct}',
              ),
              InfoPill(
                icon: Icons.groups_rounded,
                label: '${_heroes.length} héroes',
              ),
              InfoPill(
                icon: Icons.map_rounded,
                label: '${_campaign.pendingLevelsCount} pendientes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingLevelsSection() {
    return SectionCard(
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
          if (_isLoadingLevels)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_currentLevels.isEmpty)
            const Text(
              'No hay mapas pendientes.',
              style: TextStyle(color: Colors.white70),
            )
          else
            ..._currentLevels.map(
              (level) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PendingLevelTile(
                  text: '${level.name} · ${_typeLabel(level.type)}',
                ),
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
            onTap: _openPendingLevels,
          ),
          const SizedBox(height: 10),
          ActionButtonTile(
            icon: Icons.task_alt_rounded,
            label: 'Ver niveles superados',
            onTap: _openCompletedLevels,
          ),
          const SizedBox(height: 10),
          ActionButtonTile(
            icon: Icons.block_rounded,
            label: 'Ver niveles descartados',
            onTap: _openDiscardedLevels,
          ),
          const SizedBox(height: 10),
          ActionButtonTile(
            icon: Icons.library_books_rounded,
            label: 'Ver todos los niveles',
            onTap: _openAllLevels,
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
      onPressed: _advanceAct,
      icon: const Icon(Icons.auto_awesome_rounded),
      label: const Text(
        'Pasar de acto',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
