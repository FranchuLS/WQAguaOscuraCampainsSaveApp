import '../models/act_level_template.dart';
import '../models/campaign.dart';
import '../models/campaign_level.dart';
import 'campaign_level_repository.dart';
import 'campaign_repository.dart';
import 'level_template_loader.dart';

class CampaignLevelService {
  final CampaignLevelRepository _levelRepository = CampaignLevelRepository();
  final CampaignRepository _campaignRepository = CampaignRepository();
  final LevelTemplateLoader _templateLoader = LevelTemplateLoader();

  LevelType _mapType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'lugar de descanso':
        return LevelType.safePlace;
      case 'encuentro':
        return LevelType.encounter;
      case 'evento':
        return LevelType.event;
      case 'jefe':
        return LevelType.boss;
      default:
        throw Exception('Tipo de nivel no soportado: $type');
    }
  }

  Future<Campaign> bootstrapActLevels(Campaign campaign) async {
    final existingLevels = _levelRepository.getLevelsByCampaignAndAct(
      campaign.id,
      campaign.currentAct,
    );

    if (existingLevels.isNotEmpty) {
      final pendingRounds = _levelRepository.getPendingRoundsCount(
        campaign.id,
        campaign.currentAct,
      );

      final updatedCampaign = campaign.copyWith(
        pendingLevelsCount: pendingRounds,
      );

      await _campaignRepository.saveCampaign(updatedCampaign);
      return updatedCampaign;
    }

    final actDefinition = await _templateLoader.loadActDefinition(
      campaign.currentAct,
    );

    if (actDefinition == null) {
      final updatedCampaign = campaign.copyWith(pendingLevelsCount: 0);
      await _campaignRepository.saveCampaign(updatedCampaign);
      return updatedCampaign;
    }

    final shuffledRegular = List<ActLevelTemplate>.from(
      actDefinition.regularLevels,
    )..shuffle();

    final selectedRegular = shuffledRegular.take(14).toList();

    final shuffledBosses = List<ActLevelTemplate>.from(actDefinition.bossLevels)
      ..shuffle();

    final selectedBoss = shuffledBosses.first;

    final List<CampaignLevel> levels = [];

    for (var index = 0; index < selectedRegular.length; index++) {
      final level = selectedRegular[index];
      final roundIndex = (index ~/ 2) + 1;

      levels.add(
        CampaignLevel(
          id: '${campaign.id}_a${campaign.currentAct}_r${roundIndex}_$index',
          campaignId: campaign.id,
          act: campaign.currentAct,
          roundIndex: roundIndex,
          orderIndex: index + 1,
          type: _mapType(level.type),
          name: level.name,
          status: LevelStatus.pending,
        ),
      );
    }

    levels.add(
      CampaignLevel(
        id: '${campaign.id}_a${campaign.currentAct}_boss',
        campaignId: campaign.id,
        act: campaign.currentAct,
        roundIndex: 8,
        orderIndex: 15,
        type: _mapType(selectedBoss.type),
        name: selectedBoss.name,
        status: LevelStatus.pending,
      ),
    );

    await _levelRepository.saveMany(levels);

    final updatedCampaign = campaign.copyWith(pendingLevelsCount: 8);
    await _campaignRepository.saveCampaign(updatedCampaign);

    return updatedCampaign;
  }

  Future<Campaign> resolveSelectedLevel({
    required Campaign campaign,
    required String selectedLevelId,
  }) async {
    final currentLevels = _levelRepository.getCurrentRoundLevels(
      campaign.id,
      campaign.currentAct,
    );

    if (currentLevels.isEmpty) {
      return campaign;
    }

    for (final level in currentLevels) {
      final updatedLevel = level.copyWith(
        status: level.id == selectedLevelId
            ? LevelStatus.completed
            : LevelStatus.discarded,
      );

      await _levelRepository.saveLevel(updatedLevel);
    }

    final pendingRounds = _levelRepository.getPendingRoundsCount(
      campaign.id,
      campaign.currentAct,
    );

    final updatedCampaign = campaign.copyWith(
      pendingLevelsCount: pendingRounds,
    );

    await _campaignRepository.saveCampaign(updatedCampaign);
    return updatedCampaign;
  }

  Future<Campaign> advanceAct(Campaign campaign) async {
    final pendingRounds = _levelRepository.getPendingRoundsCount(
      campaign.id,
      campaign.currentAct,
    );

    if (pendingRounds > 0) {
      return campaign;
    }

    final nextAct = campaign.currentAct + 1;

    final updatedCampaign = campaign.copyWith(
      currentAct: nextAct,
      pendingLevelsCount: 0,
    );

    await _campaignRepository.saveCampaign(updatedCampaign);

    return bootstrapActLevels(updatedCampaign);
  }
}
