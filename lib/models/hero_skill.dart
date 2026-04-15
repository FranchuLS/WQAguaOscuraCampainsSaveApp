class HeroSkill {
  final String id;
  final String name;
  final int cost;

  HeroSkill({required this.id, required this.name, required this.cost});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'cost': cost};
  }

  factory HeroSkill.fromJson(Map<String, dynamic> json) {
    return HeroSkill(
      id: json['id'] as String,
      name: json['name'] as String,
      cost: json['cost'] as int,
    );
  }
}
