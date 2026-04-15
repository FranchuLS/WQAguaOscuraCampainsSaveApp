import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/act_level_template.dart';

class LevelTemplateLoader {
  static const String _assetPath = 'assets/templates/level_by_act.json';

  Future<ActDefinition?> loadActDefinition(int act) async {
    final rawJson = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final acts = (decoded['acts'] as List<dynamic>)
        .map((item) => ActDefinition.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    try {
      return acts.firstWhere((item) => item.act == act);
    } catch (_) {
      return null;
    }
  }
}
