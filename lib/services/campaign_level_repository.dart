import 'package:hive/hive.dart';
import '../models/campaign_level.dart';

class CampaignLevelRepository {
  static const String boxName = 'campaignLevelsBox';

  Box get _box => Hive.box(boxName);

  List<CampaignLevel> getLevelsByCampaign(String campaignId) {
    final levels = _box.values
        .map((item) => CampaignLevel.fromJson(Map<String, dynamic>.from(item)))
        .where((level) => level.campaignId == campaignId)
        .toList();

    levels.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return levels;
  }

  List<CampaignLevel> getLevelsByCampaignAndAct(String campaignId, int act) {
    final levels = getLevelsByCampaign(
      campaignId,
    ).where((level) => level.act == act).toList();

    levels.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return levels;
  }

  List<CampaignLevel> getPendingLevelsByCampaignAndAct(
    String campaignId,
    int act,
  ) {
    return getLevelsByCampaignAndAct(
      campaignId,
      act,
    ).where((level) => level.status == LevelStatus.pending).toList();
  }

  List<CampaignLevel> getCompletedLevelsByCampaign(String campaignId) {
    return getLevelsByCampaign(
      campaignId,
    ).where((level) => level.status == LevelStatus.completed).toList();
  }

  List<CampaignLevel> getDiscardedLevelsByCampaign(String campaignId) {
    return getLevelsByCampaign(
      campaignId,
    ).where((level) => level.status == LevelStatus.discarded).toList();
  }

  List<CampaignLevel> getCurrentRoundLevels(String campaignId, int act) {
    final pending = getPendingLevelsByCampaignAndAct(campaignId, act);

    if (pending.isEmpty) {
      return [];
    }

    final currentRound = pending
        .map((level) => level.roundIndex)
        .reduce((a, b) => a < b ? a : b);

    final currentLevels = pending
        .where((level) => level.roundIndex == currentRound)
        .toList();

    currentLevels.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return currentLevels;
  }

  int getPendingRoundsCount(String campaignId, int act) {
    final rounds = getPendingLevelsByCampaignAndAct(
      campaignId,
      act,
    ).map((level) => level.roundIndex).toSet();

    return rounds.length;
  }

  Future<void> saveLevel(CampaignLevel level) async {
    await _box.put(level.id, level.toJson());
  }

  Future<void> saveMany(List<CampaignLevel> levels) async {
    final entries = <String, dynamic>{
      for (final level in levels) level.id: level.toJson(),
    };

    await _box.putAll(entries);
  }

  Future<void> deleteLevelsByCampaign(String campaignId) async {
    final keysToDelete = _box.keys.where((key) {
      final item = _box.get(key);
      if (item is! Map) {
        return false;
      }

      final json = Map<String, dynamic>.from(item);
      return json['campaignId'] == campaignId;
    }).toList();

    await _box.deleteAll(keysToDelete);
  }
}
