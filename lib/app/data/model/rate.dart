class RatingModel {
  final int rateId;
  final String rateNote;
  final double rateStar;
  final DateTime rateDate;
  final String contractorId;
  final String contractorName;
  final String ownerId;
  final String ownerName;

  RatingModel({
    required this.rateId,
    required this.rateNote,
    required this.rateStar,
    required this.rateDate,
    required this.contractorId,
    required this.contractorName,
    required this.ownerId,
    required this.ownerName,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rateId: json["rate_Id"] as int? ?? 0,
      rateNote: json["rate_Note"] as String? ?? "",
      rateStar:( json["rate_Star"] as num? ?? 0).toDouble(),
      rateDate: DateTime.tryParse(json["rate_Date"] as String? ?? "") ??
          DateTime.now(),
      contractorId: json["contractor_Id"] as String? ?? "",
      contractorName: json["contractor_Name"] as String? ?? "",
      ownerId: json["owner_Id"] as String? ?? "",
      ownerName: json["owner_Name"] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "rate_Id": rateId,
      "rate_Note": rateNote,
      "rate_Star": rateStar,
      "rate_Date": rateDate.toIso8601String(),
      "contractor_Id": contractorId,
      "contractor_Name": contractorName,
      "owner_Id": ownerId,
      "owner_Name": ownerName,
    };
  }
}
