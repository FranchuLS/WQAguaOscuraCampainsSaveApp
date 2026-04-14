import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../widgets/action_button_tile.dart';
import '../widgets/section_card.dart';

class CampaignDetailScreen extends StatelessWidget {
  final Campaign campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  bool get _canAdvanceAct => campaign.pendingLevelsCount == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.name),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.35),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/luz_purpura.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _InfoPill(
                            icon: Icons.flag_rounded,
                            label: 'Acto ${campaign.currentAct}',
                          ),
                          _InfoPill(
                            icon: Icons.groups_rounded,
                            label: '${campaign.heroCount} héroes',
                          ),
                          _InfoPill(
                            icon: Icons.map_rounded,
                            label: '${campaign.pendingLevelsCount} pendientes',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mapas pendientes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (campaign.pendingLevelsCount == 0)
                        const Text(
                          'No hay mapas pendientes.',
                          style: TextStyle(color: Colors.white70),
                        )
                      else
                        Column(
                          children: List.generate(
                            campaign.pendingLevelsCount,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PendingLevelTile(
                                text: 'Mapa pendiente ${index + 1}',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Héroes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (campaign.heroCount == 0)
                        const Text(
                          'No hay héroes añadidos todavía.',
                          style: TextStyle(color: Colors.white70),
                        )
                      else
                        Column(
                          children: List.generate(
                            campaign.heroCount,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _HeroPreviewTile(
                                name: 'Héroe ${index + 1}',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    children: [
                      ActionButtonTile(
                        icon: Icons.groups_rounded,
                        label: 'Ver héroes',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ver héroes')),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.alt_route_rounded,
                        label: 'Ver siguientes niveles',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ver siguientes niveles'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.task_alt_rounded,
                        label: 'Ver niveles superados',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ver niveles superados'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.block_rounded,
                        label: 'Ver niveles descartados',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ver niveles descartados'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ActionButtonTile(
                        icon: Icons.library_books_rounded,
                        label: 'Ver todos los niveles',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ver todos los niveles'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_canAdvanceAct)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7ED9A3),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pasar de acto')),
                      );
                    },
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text(
                      'Pasar de acto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: const Color(0xFFA7E3BE)),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingLevelTile extends StatelessWidget {
  final String text;

  const _PendingLevelTile({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF2D2234),
      ),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _HeroPreviewTile extends StatelessWidget {
  final String name;

  const _HeroPreviewTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF1F2E2A),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withValues(alpha: 0.25),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
