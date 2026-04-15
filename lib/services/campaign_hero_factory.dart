import '../models/campaign_hero.dart';
import '../models/hero_equipment.dart';
import '../models/hero_skill.dart';
import '../models/hero_template.dart';

class CampaignHeroFactory {
  List<CampaignHero> buildInitialHeroes({
    required String campaignId,
    required List<HeroTemplate> templates,
  }) {
    return templates.map((template) {
      final timestamp = DateTime.now().microsecondsSinceEpoch.toString();

      return CampaignHero(
        id: '${campaignId}_${template.id}_$timestamp',
        campaignId: campaignId,
        templateId: template.id,
        name: template.name,
        currentState: HeroState.ok,
        currentWounds: 10,
        maxWounds: 10,
        skills: [
          HeroSkill(id: '${template.id}_move', name: 'Mover', cost: 1),
          HeroSkill(id: '${template.id}_help', name: 'Ayudar', cost: 1),
          HeroSkill(id: '${template.id}_attack', name: 'Atacar', cost: 1),
          HeroSkill(
            id: '${template.id}_special',
            name: template.specialAbilityName,
            cost: 1,
          ),
        ],
        equipment: [
          HeroEquipment(
            id: '${template.id}_equipment',
            name: template.startingEquipmentName,
          ),
        ],
        rewards: [],
        statuses: [],
      );
    }).toList();
  }
}
