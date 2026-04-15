import 'package:hive/hive.dart';
import '../models/hero_model.dart';

class HeroRepository {
  static const String boxName = 'heroesBox';

  Box get _box => Hive.box(boxName);

  List<HeroModel> getHeroesByCampaign(String campaignId) {
    final heroes = _box.values
        .map((item) => HeroModel.fromJson(Map<String, dynamic>.from(item)))
        .where((hero) => hero.campaignId == campaignId)
        .toList();

    heroes.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return heroes;
  }

  Future<void> saveHero(HeroModel hero) async {
    await _box.put(hero.id, hero.toJson());
  }

  Future<void> deleteHero(String heroId) async {
    await _box.delete(heroId);
  }
}
