import 'package:uuid/uuid.dart';

class Campaign {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<String> heroIds;

  Campaign({
    String? id,
    required this.name,
    required this.createdAt,
    this.heroIds = const [],
  }) : id = id ?? const Uuid().v4();
}