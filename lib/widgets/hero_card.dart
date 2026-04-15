import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import 'hero_info_chip.dart';

class HeroCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HeroCard({
    super.key,
    required this.hero,
    required this.onTap,
    required this.onDelete,
  });

  String get _statusLabel {
    switch (hero.status) {
      case HeroStatus.ok:
        return 'OK';
      case HeroStatus.vulnerable:
        return 'Vulnerable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2A22), Color(0xFF355844), Color(0xFF6FA98A)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black.withValues(alpha: 0.18),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          HeroInfoChip(
                            icon: Icons.health_and_safety_rounded,
                            label: '${hero.wounds} heridas',
                          ),
                          HeroInfoChip(
                            icon: Icons.warning_amber_rounded,
                            label: _statusLabel,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  iconColor: Colors.white,
                  color: const Color(0xFF203026),
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Borrar', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}