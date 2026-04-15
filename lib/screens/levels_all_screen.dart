import 'package:flutter/material.dart';

import '../models/campaign.dart';
import '../models/campaign_level.dart';
import '../services/campaign_level_repository.dart';
import '../widgets/app_background.dart';

class LevelsAllScreen extends StatelessWidget {
  final Campaign campaign;

  const LevelsAllScreen({super.key, required this.campaign});

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

  String _statusLabel(LevelStatus status) {
    switch (status) {
      case LevelStatus.pending:
        return 'Pendiente';
      case LevelStatus.completed:
        return 'Superado';
      case LevelStatus.discarded:
        return 'Descartado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = CampaignLevelRepository();
    final levels = repository.getLevelsByCampaign(campaign.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos los niveles'),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.35),
      ),
      body: AppBackground(
        child: SafeArea(
          child: levels.isEmpty
              ? const Center(
                  child: Text(
                    'No hay niveles.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: levels.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final level = levels[index];

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF1B1F2A),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          level.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Acto ${level.act} · ${_typeLabel(level.type)} · ${_statusLabel(level.status)}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
