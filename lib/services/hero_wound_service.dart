import '../models/campaign_hero.dart';

class HeroWoundService {
  CampaignHero damage(CampaignHero hero, {int amount = 1}) {
    var state = hero.currentState;
    var wounds = hero.currentWounds;

    for (var i = 0; i < amount; i++) {
      if (state == HeroState.ok) {
        if (wounds > 1) {
          wounds -= 1;
        } else {
          state = HeroState.vulnerable;
          wounds = hero.maxWounds;
        }
      } else {
        if (wounds > 0) {
          wounds -= 1;
        }
      }
    }

    return hero.copyWith(currentState: state, currentWounds: wounds);
  }

  CampaignHero heal(CampaignHero hero, {int amount = 1}) {
    var state = hero.currentState;
    var wounds = hero.currentWounds;

    for (var i = 0; i < amount; i++) {
      if (state == HeroState.vulnerable) {
        if (wounds < hero.maxWounds) {
          wounds += 1;
        } else {
          state = HeroState.ok;
          wounds = 1;
        }
      } else {
        if (wounds < hero.maxWounds) {
          wounds += 1;
        }
      }
    }

    return hero.copyWith(currentState: state, currentWounds: wounds);
  }
}
