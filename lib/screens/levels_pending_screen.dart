import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/campaign_level.dart';
import '../services/campaign_level_repository.dart';
import '../services/campaign_level_service.dart';
import '../widgets/app_background.dart';
import '../widgets/section_card.dart';

class LevelsPendingScreen extends StatefulWidget {
  final Campaign campaign;

  const LevelsPendingScreen({super.key, required this.campaign});

  @override
  State<LevelsPendingScreen> createState() => _LevelsPendingScreenState();
}

class _LevelsPendingScreenState extends State<LevelsPendingScreen> {
  final CampaignLevelRepository _repository = CampaignLevelRepository();
  final CampaignLevelService _service = CampaignLevelService();

  late Campaign _campaign;
  List<CampaignLevel> _currentLevels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _campaign = widget.campaign;
    _loadCurrentLevels();
  }

  Future<void> _loadCurrentLevels() async {
    final levels = _repository.getCurrentRoundLevels(
      _campaign.id,
      _campaign.currentAct,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _currentLevels = levels;
      _isLoading = false;
    });
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

  Future<void> _selectLevel(CampaignLevel level) async {
    final updatedCampaign = await _service.resolveSelectedLevel(
      campaign: _campaign,
      selectedLevelId: level.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _campaign = updatedCampaign;
    });

    await _loadCurrentLevels();

    if (!mounted) {
      return;
    }

    if (_currentLevels.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siguientes niveles'),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.35),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _currentLevels.isEmpty
                ? const Center(
                    child: Text(
                      'No hay niveles pendientes.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentLevels.length == 1
                              ? 'Jefe del acto'
                              : 'Elige uno de estos niveles',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._currentLevels.map(
                          (level) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SelectableLevelCard(
                              level: level,
                              typeLabel: _typeLabel(level.type),
                              onSelect: () => _selectLevel(level),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SelectableLevelCard extends StatelessWidget {
  final CampaignLevel level;
  final String typeLabel;
  final VoidCallback onSelect;

  const _SelectableLevelCard({
    required this.level,
    required this.typeLabel,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2E2A),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            typeLabel,
            style: const TextStyle(
              color: Color(0xFFA7E3BE),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSelect,
              child: const Text('Elegir este nivel'),
            ),
          ),
        ],
      ),
    );
  }
}
