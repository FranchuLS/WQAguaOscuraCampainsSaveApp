class Campaign {
  final String id;
  final String name;
  final int currentAct;
  final int heroCount;
  final int pendingLevelsCount;

  Campaign({
    required this.id,
    required this.name,
    required this.currentAct,
    required this.heroCount,
    required this.pendingLevelsCount,
  });

  Campaign copyWith({
    String? id,
    String? name,
    int? currentAct,
    int? heroCount,
    int? pendingLevelsCount,
  }) {
    return Campaign(
      id: id ?? this.id,
      name: name ?? this.name,
      currentAct: currentAct ?? this.currentAct,
      heroCount: heroCount ?? this.heroCount,
      pendingLevelsCount: pendingLevelsCount ?? this.pendingLevelsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currentAct': currentAct,
      'heroCount': heroCount,
      'pendingLevelsCount': pendingLevelsCount,
    };
  }

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as String,
      name: json['name'] as String,
      currentAct: json['currentAct'] as int,
      heroCount: json['heroCount'] as int,
      pendingLevelsCount: json['pendingLevelsCount'] as int,
    );
  }
}
