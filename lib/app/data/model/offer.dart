class ProjectOffer {
  final String offerId;
  final double offerPrice;
  final int offerDuration;
  final String offerDescription;
  final DateTime dateAdded;
  final String contractorId;
  final String fullName;
  final String projectId;
  final int priorityLevel;
  final int conversationId;

  ProjectOffer({
    required this.offerId,
    required this.offerPrice,
    required this.offerDuration,
    required this.offerDescription,
    required this.dateAdded,
    required this.contractorId,
    required this.fullName,
    required this.projectId,
    required this.priorityLevel,
    required this.conversationId,
  });

  factory ProjectOffer.fromJson(Map<String, dynamic> json) => ProjectOffer(
    offerId: json["offer_Id"] as String? ?? "",
    offerPrice: (json["offer_Price"] as num?)?.toDouble() ?? 0.0,
    offerDuration: json["offer_Duration"] as int? ?? 0,
    offerDescription: json["offer_Description"] as String? ?? "",
    dateAdded:
    DateTime.tryParse(json["date_Added"] ?? "") ?? DateTime.now(),
    contractorId: json["contractor_Id"] as String? ?? "",
    fullName: json["full_Name"] as String? ?? "",
    projectId: json["project_Id"] as String? ?? "",
    priorityLevel: json["priority_Level"] as int? ?? 0,
    conversationId: _parseConversationId(json["converstion_Id"]),
  );

  Map<String, dynamic> toJson() => {
    "offer_Id": offerId,
    "offer_Price": offerPrice,
    "offer_Duration": offerDuration,
    "offer_Description": offerDescription,
    "date_Added": dateAdded.toIso8601String(),
    "contractor_Id": contractorId,
    "full_Name": fullName,
    "project_Id": projectId,
    "priority_Level": priorityLevel,
    "converstion_Id": conversationId,
  };

  ProjectOffer copyWith({
    String? offerId,
    double? offerPrice,
    int? offerDuration,
    String? offerDescription,
    DateTime? dateAdded,
    String? contractorId,
    String? fullName,
    String? projectId,
    int? priorityLevel,
    int? conversationId,
  }) {
    return ProjectOffer(
      offerId: offerId ?? this.offerId,
      offerPrice: offerPrice ?? this.offerPrice,
      offerDuration: offerDuration ?? this.offerDuration,
      offerDescription: offerDescription ?? this.offerDescription,
      dateAdded: dateAdded ?? this.dateAdded,
      contractorId: contractorId ?? this.contractorId,
      fullName: fullName ?? this.fullName,
      projectId: projectId ?? this.projectId,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      conversationId: conversationId ?? this.conversationId,
    );
  }

  static int _parseConversationId(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
