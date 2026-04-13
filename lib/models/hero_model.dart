class HeroModel {
  final String id;
  final String name;
  final int level;
  final int gold;

  HeroModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.gold = 0,
  });
}