class CampaignAvatarService {
  final List<String> _heroImages = const [
    'assets/images/caballera.png',
    'assets/images/doncella.png',
    'assets/images/explorador.png',
    'assets/images/guerrero.png',
  ];

  final Map<String, String> _campaignImages = {};

  String getImageForCampaign(String campaignId) {
    if (_campaignImages.containsKey(campaignId)) {
      return _campaignImages[campaignId]!;
    }

    final usedImages = _campaignImages.values.toSet();
    final availableImages = _heroImages
        .where((image) => !usedImages.contains(image))
        .toList();

    final selectedImage = availableImages.isNotEmpty
        ? (List<String>.from(availableImages)..shuffle()).first
        : (List<String>.from(_heroImages)..shuffle()).first;

    _campaignImages[campaignId] = selectedImage;
    return selectedImage;
  }

  void removeCampaign(String campaignId) {
    _campaignImages.remove(campaignId);
  }
}
