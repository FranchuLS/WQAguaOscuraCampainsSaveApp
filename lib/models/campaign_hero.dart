import 'hero_equipment.dart';
import 'hero_reward.dart';
import 'hero_skill.dart';

enum HeroState { ok, vulnerable }

class CampaignHero {
  final String id;
  final String campaignId;
  final String templateId;
  final String name;
  final HeroState currentState;
  final int currentWounds;
  final int maxWounds;
  final List<HeroSkill> skills;
  final List<HeroEquipment> equipment;
  final List<HeroReward> rewards;
  final List<String> statuses;

  CampaignHero({
    required this.id,
    required this.campaignId,
    required this.templateId,
    required this.name,
    required this.currentState,
    required this.currentWounds,
    required this.maxWounds,
    required this.skills,
    required this.equipment,
    required this.rewards,
    required this.statuses,
  });

  CampaignHero copyWith({
    String? id,
    String? campaignId,
    String? templateId,
    String? name,
    HeroState? currentState,
    int? currentWounds,
    int? maxWounds,
    List<HeroSkill>? skills,
    List<HeroEquipment>? equipment,
    List<HeroReward>? rewards,
    List<String>? statuses,
  }) {
    return CampaignHero(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      currentState: currentState ?? this.currentState,
      currentWounds: currentWounds ?? this.currentWounds,
      maxWounds: maxWounds ?? this.maxWounds,
      skills: skills ?? this.skills,
      equipment: equipment ?? this.equipment,
      rewards: rewards ?? this.rewards,
      statuses: statuses ?? this.statuses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'templateId': templateId,
      'name': name,
      'currentState': currentState.name,
      'currentWounds': currentWounds,
      'maxWounds': maxWounds,
      'skills': skills.map((item) => item.toJson()).toList(),
      'equipment': equipment.map((item) => item.toJson()).toList(),
      'rewards': rewards.map((item) => item.toJson()).toList(),
      'statuses': statuses,
    };
  }

  factory CampaignHero.fromJson(Map<String, dynamic> json) {
    return CampaignHero(
      id: json['id'] as String,
      campaignId: json['campaignId'] as String,
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      currentState: HeroState.values.firstWhere(
        (value) => value.name == json['currentState'],
      ),
      currentWounds: json['currentWounds'] as int,
      maxWounds: json['maxWounds'] as int,
      skills: (json['skills'] as List<dynamic>)
          .map((item) => HeroSkill.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      equipment: (json['equipment'] as List<dynamic>)
          .map(
            (item) => HeroEquipment.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      rewards: (json['rewards'] as List<dynamic>)
          .map((item) => HeroReward.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      statuses: List<String>.from(json['statuses'] as List<dynamic>),
    );
  }
}
