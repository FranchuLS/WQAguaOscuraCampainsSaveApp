import 'package:flutter/material.dart';
import 'package:wqaguaoscura_app/screens/campaign_detail_screen.dart';
import '../models/campaign.dart';
import '../services/campaign_avatar_service.dart';
import '../services/campaign_repository.dart';
import '../services/campaign_hero_factory.dart';
import '../services/campaign_hero_repository.dart';
import '../services/hero_template_loader.dart';
import '../widgets/campaign_card.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final CampaignAvatarService _avatarService = CampaignAvatarService();
  final CampaignRepository _repository = CampaignRepository();
  final CampaignHeroRepository _heroRepository = CampaignHeroRepository();
  final HeroTemplateLoader _heroTemplateLoader = HeroTemplateLoader();
  final CampaignHeroFactory _heroFactory = CampaignHeroFactory();

  List<Campaign> _campaigns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  void _loadCampaigns() {
    final campaigns = _repository.getAllCampaigns();

    setState(() {
      _campaigns = campaigns;
      _isLoading = false;
    });
  }

  Future<void> _showCreateCampaignDialog() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
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
              if (name.isEmpty) {
                return;
              }
              Navigator.pop(context, name);
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) {
      return;
    }

    final campaignId = DateTime.now().millisecondsSinceEpoch.toString();

    final campaign = Campaign(
      id: campaignId,
      name: result,
      currentAct: 1,
      heroCount: 4,
      pendingLevelsCount: 0,
    );

    final templates = await _heroTemplateLoader.loadTemplates();
    final initialHeroes = _heroFactory.buildInitialHeroes(
      campaignId: campaignId,
      templates: templates,
    );

    await _repository.saveCampaign(campaign);
    await _heroRepository.saveMany(initialHeroes);

    _loadCampaigns();
  }

  Future<void> _deleteCampaign(Campaign campaign) async {
    await _repository.deleteCampaign(campaign.id);
    await _heroRepository.deleteHeroesByCampaign(campaign.id);

    setState(() {
      _campaigns.removeWhere((item) => item.id == campaign.id);
      _avatarService.removeCampaign(campaign.id);
    });
  }

  void _openCampaign(Campaign campaign) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CampaignDetailScreen(campaign: campaign),
      ),
    );
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
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_campaigns.isEmpty)
            const Center(
              child: Text(
                'No hay campañas',
                style: TextStyle(color: Colors.white),
              ),
            )
          else
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _campaigns.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final campaign = _campaigns[index];
                return CampaignCard(
                  campaign: campaign,
                  imagePath: _avatarService.getImageForCampaign(campaign.id),
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
