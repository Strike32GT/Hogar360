class ProfileSummary {
  const ProfileSummary({
    required this.calculationsCount,
    required this.completionPercentage,
  });

  final int calculationsCount;
  final int completionPercentage;

  factory ProfileSummary.fromJson(Map<String, dynamic> json) {
    return ProfileSummary(
      calculationsCount: (json['calculationsCount'] as num?)?.toInt() ?? 0,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toInt() ?? 0,
    );
  }
}
