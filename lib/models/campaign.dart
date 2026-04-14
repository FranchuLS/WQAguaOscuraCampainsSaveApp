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
}
