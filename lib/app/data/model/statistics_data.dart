class StatisticsData {
  final int projects;
  final int offers;
  final int users;
  final int remainingOffers;
  final double rating;

  StatisticsData({
    required this.projects,
    required this.offers,
    required this.users,
    required this.remainingOffers,
    required this.rating,
  });
  
  factory StatisticsData.fromJson(Map<String, dynamic> json) => StatisticsData(
    projects: json['projects'] as int? ?? 0,
    offers: json['offers'] as int? ?? 0,
    rating: (json['rating'] as num? ?? 0).toDouble(),
    users: json['users'] as int? ?? 0,
    remainingOffers: json['remaining_Offers'] as int? ?? 0,
  );
}