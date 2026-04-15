import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/campaign_level.dart';
import '../services/campaign_level_repository.dart';
import '../widgets/app_background.dart';
import '../widgets/section_card.dart';

class LevelsCompletedScreen extends StatelessWidget {
  final Campaign campaign;

  const LevelsCompletedScreen({super.key, required this.campaign});

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
    final repository = CampaignLevelRepository();
    final levels = repository.getCompletedLevelsByCampaign(campaign.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Niveles superados'),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.35),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: levels.isEmpty
                ? const Center(
                    child: Text(
                      'No hay niveles superados.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SectionCard(
                    child: Column(
                      children: levels
                          .map(
                            (level) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                level.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Acto ${level.act} · ${_typeLabel(level.type)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
