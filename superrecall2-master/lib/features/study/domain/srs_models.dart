class ReviewInterval {
  const ReviewInterval({
    required this.itemId,
    required this.nextReviewDate,
    required this.intervalDays,
    required this.easeFactor,
    required this.repetitions,
    this.lastReviewedDate,
  });

  final String itemId;
  final DateTime nextReviewDate;
  final DateTime? lastReviewedDate;
  final int intervalDays;
  final double easeFactor;
  final int repetitions;

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'nextReviewDate': nextReviewDate.toIso8601String(),
        'lastReviewedDate': lastReviewedDate?.toIso8601String(),
        'intervalDays': intervalDays,
        'easeFactor': easeFactor,
        'repetitions': repetitions,
      };

  factory ReviewInterval.fromJson(Map<String, dynamic> json) => ReviewInterval(
        itemId: json['itemId'] as String,
        nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
        lastReviewedDate: json['lastReviewedDate'] != null 
            ? DateTime.parse(json['lastReviewedDate'] as String) 
            : null,
        intervalDays: json['intervalDays'] as int,
        easeFactor: (json['easeFactor'] as num).toDouble(),
        repetitions: json['repetitions'] as int? ?? 0,
      );
}
