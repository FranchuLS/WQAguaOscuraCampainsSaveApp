class HeroReward {
  final String id;
  final String description;
  final int goldValue;

  HeroReward({
    required this.id,
    required this.description,
    this.goldValue = 0,
  });
}