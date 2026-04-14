import 'package:hive/hive.dart';
import '../models/campaign.dart';

class CampaignRepository {
  static const String boxName = 'campaignsBox';

  Box get _box => Hive.box(boxName);

  List<Campaign> getAllCampaigns() {
    final campaigns = _box.values
        .map((item) => Campaign.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    campaigns.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    return campaigns;
  }

  Future<void> saveCampaign(Campaign campaign) async {
    await _box.put(campaign.id, campaign.toJson());
  }

  Future<void> deleteCampaign(String campaignId) async {
    await _box.delete(campaignId);
  }
}
