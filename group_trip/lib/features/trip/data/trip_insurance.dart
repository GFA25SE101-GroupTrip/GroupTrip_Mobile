class TripInsurance {
  final String id;
  final String name;
  final String providerName;
  final int price;
  final String benefit;
  final int maxCoverageAmount;
  final bool isActive;
  final String? pdfAttachment;

  TripInsurance({
    required this.id,
    required this.name,
    required this.providerName,
    required this.price,
    required this.benefit,
    required this.maxCoverageAmount,
    required this.isActive,
    this.pdfAttachment,
  });

  factory TripInsurance.fromJson(Map<String, dynamic> json) {
    return TripInsurance(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      providerName: json['providerName'] ?? '',
      price: json['price'] is int ? json['price'] : (json['price'] as num?)?.toInt() ?? 0,
      benefit: json['benefit'] ?? '',
      maxCoverageAmount: json['maxCoverageAmount'] is int ? json['maxCoverageAmount'] : (json['maxCoverageAmount'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] ?? true,
      pdfAttachment: json['pdfAttachment'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'providerName': providerName,
        'price': price,
        'benefit': benefit,
        'maxCoverageAmount': maxCoverageAmount,
        'isActive': isActive,
        'pdfAttachment': pdfAttachment,
      };
}
