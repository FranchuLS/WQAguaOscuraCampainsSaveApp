enum LevelType { safePlace, encounter, event, boss }

enum LevelStatus { pending, completed, discarded }

class CampaignLevel {
  final String id;
  final String campaignId;
  final int act;
  final int roundIndex; // 1..7 parejas, 8 = jefe
  final int orderIndex; // orden interno del acto
  final LevelType type;
  final String name;
  final LevelStatus status;

  CampaignLevel({
    required this.id,
    required this.campaignId,
    required this.act,
    required this.roundIndex,
    required this.orderIndex,
    required this.type,
    required this.name,
    required this.status,
  });

  CampaignLevel copyWith({
    String? id,
    String? campaignId,
    int? act,
    int? roundIndex,
    int? orderIndex,
    LevelType? type,
    String? name,
    LevelStatus? status,
  }) {
    return CampaignLevel(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      act: act ?? this.act,
      roundIndex: roundIndex ?? this.roundIndex,
      orderIndex: orderIndex ?? this.orderIndex,
      type: type ?? this.type,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'act': act,
      'roundIndex': roundIndex,
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
      roundIndex: json['roundIndex'] as int,
      orderIndex: json['orderIndex'] as int,
      type: LevelType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'] as String,
      status: LevelStatus.values.firstWhere((e) => e.name == json['status']),
    );
  }
}
