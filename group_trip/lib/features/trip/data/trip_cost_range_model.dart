class TripCostRange {
  final String id; 
  final int minTraveller;
  final int maxTraveller;
  final int price;
  TripCostRange({
    required this.id,
    required this.minTraveller,
    required this.maxTraveller,
    required this.price,
  });
  factory TripCostRange.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      try {
        return int.parse(v.toString());
      } catch (_) {
        return 0;
      }
    }

    return TripCostRange(
      id: json['id'],
      minTraveller: _parseInt(json['minTraveller']),
      maxTraveller: _parseInt(json['maxTraveller']),
      price: _parseInt(json['price']),
    );

  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'minTraveller': minTraveller,
        'maxTraveller': maxTraveller,
        'price': price,
  };
}
