import 'package:flutter/material.dart';
import '../models/campaign.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final List<Campaign> _campaigns = [
    Campaign(
      id: '1',
      name: 'Grupo Viernes',
      currentAct: 1,
      heroCount: 4,
      pendingLevelsCount: 3,
    ),
    Campaign(
      id: '2',
      name: 'Grupo Domingo',
      currentAct: 2,
      heroCount: 3,
      pendingLevelsCount: 2,
    ),
  ];

  final List<String> _heroImages = [
    'assets/images/caballera.png',
    'assets/images/doncella.png',
    'assets/images/explorador.png',
    'assets/images/guerrero.png',
  ];

  final Map<String, String> _campaignImages = {};

  String _assignImageToCampaign(String campaignId) {
    if (_campaignImages.containsKey(campaignId)) {
      return _campaignImages[campaignId]!;
    }

    final usedImages = _campaignImages.values.toSet();

    final availableImages = _heroImages
        .where((image) => !usedImages.contains(image))
        .toList();

    final String selectedImage;

    if (availableImages.isNotEmpty) {
      availableImages.shuffle();
      selectedImage = availableImages.first;
    } else {
      final fallbackImages = List<String>.from(_heroImages)..shuffle();
      selectedImage = fallbackImages.first;
    }

    _campaignImages[campaignId] = selectedImage;
    return selectedImage;
  }

  void _deleteCampaign(Campaign campaign) {
    setState(() {
      _campaigns.removeWhere((c) => c.id == campaign.id);
      _campaignImages.remove(campaign.id);
    });
  }

  late final List<String> _shuffledImages;

  @override
  void initState() {
    super.initState();
    _shuffledImages = List<String>.from(_heroImages)..shuffle();
  }

  Future<void> _showCreateCampaignDialog() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16211C),
        title: const Text(
          'Nueva campaña',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nombre',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF24362C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(context, name);
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    setState(() {
      _campaigns.add(
        Campaign(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result,
          currentAct: 1,
          heroCount: 0,
          pendingLevelsCount: 0,
        ),
      );
    });
  }

  void _openCampaign(Campaign campaign) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Abrir ${campaign.name}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Campañas'),
        centerTitle: true,
        backgroundColor: Colors.black.withValues(alpha: 0.45),
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
          _campaigns.isEmpty
              ? const Center(
                  child: Text(
                    'No hay campañas',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _campaigns.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final campaign = _campaigns[index];
                    return _CampaignCard(
                      campaign: campaign,
                      imagePath: _assignImageToCampaign(campaign.id),
                      onTap: () => _openCampaign(campaign),
                      onDelete: () => _deleteCampaign(campaign),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCampaignDialog,
        backgroundColor: const Color(0xFF6BBF8B),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String imagePath;

  const _CampaignCard({
    required this.campaign,
    required this.imagePath,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A2A22), Color(0xFF355844), Color(0xFF6FA98A)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withValues(alpha: 0.20),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _Chip(
                            icon: Icons.flag,
                            text: 'Acto ${campaign.currentAct}',
                          ),
                          _Chip(
                            icon: Icons.groups,
                            text: '${campaign.heroCount} héroes',
                          ),
                          _Chip(
                            icon: Icons.map,
                            text: '${campaign.pendingLevelsCount} mapas',
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
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Borrar',
                        style: TextStyle(color: Colors.white),
                      ),
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

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Chip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
