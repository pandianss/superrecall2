class EngagementMetrics {
  const EngagementMetrics({
    required this.totalXp,
    required this.currentStreak,
    required this.lastStudyDate,
    required this.studyHistory,
  });

  final int totalXp;
  final int currentStreak;
  final DateTime? lastStudyDate;
  final Map<String, int> studyHistory; // ISO date string -> XP earned that day

  int get level => (totalXp / 500).floor() + 1;
  double get levelProgress => (totalXp % 500) / 500;

  Map<String, dynamic> toJson() => {
        'totalXp': totalXp,
        'currentStreak': currentStreak,
        'lastStudyDate': lastStudyDate?.toIso8601String(),
        'studyHistory': studyHistory,
      };

  factory EngagementMetrics.fromJson(Map<String, dynamic> json) =>
      EngagementMetrics(
        totalXp: json['totalXp'] as int,
        currentStreak: json['currentStreak'] as int,
        lastStudyDate: json['lastStudyDate'] == null
            ? null
            : DateTime.parse(json['lastStudyDate'] as String),
        studyHistory: Map<String, int>.from(json['studyHistory'] as Map),
      );

  static EngagementMetrics empty() => EngagementMetrics(
        totalXp: 0,
        currentStreak: 0,
        lastStudyDate: null,
        studyHistory: {},
      );
}
