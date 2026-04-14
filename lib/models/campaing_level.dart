enum LevelType { safePlace, encounter, event, boss }

enum LevelStatus { pending, completed, discarded }

class CampaignLevel {
  final String id;
  final String campaignId;
  final int act;
  final int orderIndex;
  final LevelType type;
  final String name;
  final LevelStatus status;

  CampaignLevel({
    required this.id,
    required this.campaignId,
    required this.act,
    required this.orderIndex,
    required this.type,
    required this.name,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'act': act,
      'orderIndex': orderIndex,
      'type': type.name,
      'name': name,
      'status': status.name,
    };
  }

  factory CampaignLevel.fromJson(Map<String, dynamic> json) {
    return CampaignLevel(
      id: json['id'] as String,
      campaignId: json['campaignId'] as String,
      act: json['act'] as int,
      orderIndex: json['orderIndex'] as int,
      type: LevelType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'] as String,
      status: LevelStatus.values.firstWhere((e) => e.name == json['status']),
    );
  }
}
