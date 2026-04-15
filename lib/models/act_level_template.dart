class ActLevelTemplate {
  final String type;
  final String name;

  const ActLevelTemplate({required this.type, required this.name});

  factory ActLevelTemplate.fromJson(Map<String, dynamic> json) {
    return ActLevelTemplate(
      type: json['type'] as String,
      name: json['name'] as String,
    );
  }
}

class ActDefinition {
  final int act;
  final List<ActLevelTemplate> regularLevels;
  final List<ActLevelTemplate> bossLevels;

  const ActDefinition({
    required this.act,
    required this.regularLevels,
    required this.bossLevels,
  });

  factory ActDefinition.fromJson(Map<String, dynamic> json) {
    return ActDefinition(
      act: json['act'] as int,
      regularLevels: (json['regularLevels'] as List<dynamic>)
          .map(
            (item) => ActLevelTemplate.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      bossLevels: (json['bossLevels'] as List<dynamic>)
          .map(
            (item) => ActLevelTemplate.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
