import 'package:hive/hive.dart';
import '../models/campaign_hero.dart';

class CampaignHeroRepository {
  static const String boxName = 'campaignHeroesBox';

  Box get _box => Hive.box(boxName);

  List<CampaignHero> getHeroesByCampaign(String campaignId) {
    final heroes = _box.values
        .map((item) => CampaignHero.fromJson(Map<String, dynamic>.from(item)))
        .where((hero) => hero.campaignId == campaignId)
        .toList();

    heroes.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return heroes;
  }

  Future<void> saveHero(CampaignHero hero) async {
    await _box.put(hero.id, hero.toJson());
  }

  Future<void> saveMany(List<CampaignHero> heroes) async {
    final Map<String, dynamic> entries = {
      for (final hero in heroes) hero.id: hero.toJson(),
    };

    await _box.putAll(entries);
  }

  Future<void> deleteHero(String heroId) async {
    await _box.delete(heroId);
  }

  Future<void> deleteHeroesByCampaign(String campaignId) async {
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
