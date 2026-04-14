enum HeroStatus { ok, vulnerable }

class HeroModel {
  final String id;
  final String campaignId;
  final String name;
  final HeroStatus status;
  final int wounds;

  HeroModel({
    required this.id,
    required this.campaignId,
    required this.name,
    required this.status,
    required this.wounds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'name': name,
      'status': status.name,
      'wounds': wounds,
    };
  }

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json['id'] as String,
      campaignId: json['campaignId'] as String,
      name: json['name'] as String,
      status: HeroStatus.values.firstWhere((e) => e.name == json['status']),
      wounds: json['wounds'] as int,
    );
  }
}
