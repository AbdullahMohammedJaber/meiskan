class StatisticsModel {
  final int totalProjects;
  final int completedProjects;
  final int inProgressProjects;
  final int pendingProjects;
  final double totalEarnings;

  StatisticsModel({
    required this.totalProjects,
    required this.completedProjects,
    required this.inProgressProjects,
    required this.pendingProjects,
    required this.totalEarnings,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) => StatisticsModel(
        totalProjects: json["totalProjects"] as int? ?? 0,
        completedProjects: json["completedProjects"] as int? ?? 0,
        inProgressProjects: json["inProgressProjects"] as int? ?? 0,
        pendingProjects: json["pendingProjects"] as int? ?? 0,
        totalEarnings: (json["totalEarnings"] as num?)?.toDouble() ?? 0.0,
      );
}