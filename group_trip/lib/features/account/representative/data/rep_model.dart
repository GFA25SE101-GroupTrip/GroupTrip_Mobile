
class RepModel {
  final String travelRepresentativeProfileId;
  final String userId;
  final String? businessLicense;
  final String? description;
  final String? hotline;
  final String? contactName;
  final String? address;
  final String? websiteUrl;
  final String? socialMedia;
  final DateTime? createdAt;

  RepModel({
    required this.travelRepresentativeProfileId,
    required this.userId,
    this.businessLicense,
    this.description,
    this.hotline,
    this.contactName,
    this.address,
    this.websiteUrl,
    this.socialMedia,
    this.createdAt,
  });

  factory RepModel.fromJson(Map<String, dynamic> json) {
    return RepModel(
      travelRepresentativeProfileId: json['travelRepresentativeProfileId'] as String,
      userId: json['userId'] as String,
      businessLicense: json['business_license'] as String?, // nullable
      description: json['description'] as String?,
      hotline: json['hotline'] as String?,
      contactName: json['contact_name'] as String?,
      address: json['address'] as String?,
      websiteUrl: json['website_url'] as String?,
      socialMedia: json['social_media'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
