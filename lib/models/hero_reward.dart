class HeroReward {
  final String id;
  final String rarity;
  final String name;

  HeroReward({required this.id, required this.rarity, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'rarity': rarity, 'name': name};
  }

  factory HeroReward.fromJson(Map<String, dynamic> json) {
    return HeroReward(
      id: json['id'] as String,
      rarity: json['rarity'] as String,
      name: json['name'] as String,
    );
  }
}
