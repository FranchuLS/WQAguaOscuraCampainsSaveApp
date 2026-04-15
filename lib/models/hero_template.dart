class HeroTemplate {
  final String id;
  final String name;
  final String specialAbilityName;
  final String startingEquipmentName;

  const HeroTemplate({
    required this.id,
    required this.name,
    required this.specialAbilityName,
    required this.startingEquipmentName,
  });

  factory HeroTemplate.fromJson(Map<String, dynamic> json) {
    return HeroTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      specialAbilityName: json['specialAbilityName'] as String,
      startingEquipmentName: json['startingEquipmentName'] as String,
    );
  }
}
