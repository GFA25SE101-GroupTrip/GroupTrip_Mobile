class TripCostRange {
  final double? minCost;
  final double? maxCost;

  TripCostRange({this.minCost, this.maxCost});

  factory TripCostRange.fromJson(Map<String, dynamic> json) {
    return TripCostRange(
      minCost: (json['minCost'] ?? 0).toDouble(),
      maxCost: (json['maxCost'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'minCost': minCost,
        'maxCost': maxCost,
      };
}
