class Campaign {
  final String id;
  final String name;
  final int currentAct;

  Campaign({required this.id, required this.name, required this.currentAct});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'currentAct': currentAct};
  }

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as String,
      name: json['name'] as String,
      currentAct: json['currentAct'] as int,
    );
  }
}
