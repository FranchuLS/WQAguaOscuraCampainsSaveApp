class HeroEquipment {
  final String id;
  final String name;

  HeroEquipment({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory HeroEquipment.fromJson(Map<String, dynamic> json) {
    return HeroEquipment(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
