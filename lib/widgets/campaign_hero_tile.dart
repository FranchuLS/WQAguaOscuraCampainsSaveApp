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

  String get _imagePath {
    switch (hero.name.trim().toLowerCase()) {
      case 'bren tylis':
        return 'assets/images/heroes/bren_tylis.png';

      case 'drolf cabezahierro':
        return 'assets/images/heroes/drolf_cabezahierro.png';

      case 'edmark valoran':
        return 'assets/images/heroes/edmark_valoran.png';

      case 'inara sion':
        return 'assets/images/heroes/inara_sion.png';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _imagePath.isNotEmpty;

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
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withValues(alpha: 0.25),
                  image: hasImage
                      ? DecorationImage(
                          image: AssetImage(_imagePath),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: hasImage
                    ? null
                    : const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
                    const SizedBox(height: 3),
                    Text(
                      _statusesLabel,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
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
