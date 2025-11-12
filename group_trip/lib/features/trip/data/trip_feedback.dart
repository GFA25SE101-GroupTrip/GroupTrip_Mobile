class TripFeedback {
  final String? userId;
  final String? comment;
  final double? rating;

  TripFeedback({this.userId, this.comment, this.rating});

  factory TripFeedback.fromJson(Map<String, dynamic> json) {
    return TripFeedback(
      userId: json['userId'],
      comment: json['comment'],
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'comment': comment,
        'rating': rating,
      };
}
