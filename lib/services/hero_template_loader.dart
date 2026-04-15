import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hero_template.dart';

class HeroTemplateLoader {
  static const String _assetPath = 'assets/templates/hero_templates.json';

  Future<List<HeroTemplate>> loadTemplates() async {
    final rawJson = await rootBundle.loadString(_assetPath);
    final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;

    return decoded
        .map(
          (item) =>
              HeroTemplate.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
