import 'package:flutter/material.dart';
import '../models/campaign_hero.dart';

class CampaignHeroTile extends StatelessWidget {
  final CampaignHero hero;
  final VoidCallback onTap;

  const CampaignHeroTile({super.key, required this.hero, required this.onTap});

  String get _stateLabel {
    switch (hero.currentState) {
      case HeroState.ok:
        return 'OK';
      case HeroState.vulnerable:
        return 'Vulnerable';
    }
  }

  String get _statusesLabel {
    if (hero.statuses.isEmpty) {
      return 'Sin estados';
    }
    return hero.statuses.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFF1F2E2A),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withValues(alpha: 0.25),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estado: $_stateLabel · Heridas: ${hero.currentWounds}/${hero.maxWounds}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _statusesLabel,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}