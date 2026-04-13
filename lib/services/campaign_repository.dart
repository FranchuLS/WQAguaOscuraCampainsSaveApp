import 'package:wqaguaoscura_app/models/campaign.dart';
import 'package:wqaguaoscura_app/services/hive_service.dart';

class CampaignRepository {
  final String _boxName = HiveService.campaignBoxName;

  List<Campaign> getAllCampaigns() {
    // Lógica para obtener de Hive
    return [];
  }

  Future<void> saveCampaign(Campaign campaign) async {}
}