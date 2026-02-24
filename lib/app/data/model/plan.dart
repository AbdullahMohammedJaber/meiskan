class PointOfferModel {
  final int pointOfferId;
  final String name;
  final String nameEn;
  final int offerNum;
  final double basicPrice;
  final double afterDiscountPrice;
  final bool isActive;

  PointOfferModel({
    required this.pointOfferId,
    required this.name,
    required this.nameEn,
    required this.offerNum,
    required this.basicPrice,
    required this.afterDiscountPrice,
    required this.isActive,
  });

  factory PointOfferModel.fromJson(Map<String, dynamic> json) => PointOfferModel(
    pointOfferId: json["point_Offer_Id"] as int? ?? 0,
    name: json["name"] as String? ?? "",
    nameEn: json["name_En"] as String? ?? "",
    offerNum: json["offer_Num"] as int? ?? 0,
    basicPrice: (json["basic_Price"] as num?)?.toDouble() ?? 0.0,
    afterDiscountPrice: (json["after_Discount_Price"] as num?)?.toDouble() ?? 0.0,
    isActive: json["is_Active"] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    "point_Offer_Id": pointOfferId,
    "name": name,
    "name_En": nameEn,
    "offer_Num": offerNum,
    "basic_Price": basicPrice,
    "after_Discount_Price": afterDiscountPrice,
    "is_Active": isActive,
  };
}
/*
class PointOfferModel {
  final int planId;
  final String planNameAr;
  final String planNameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double priceMonthly;
  final String currency;
  final bool isActive;
  final int offersLimit;
  final int priorityLevel;
  final int supportLevel;

  PointOfferModel({
    required this.planId,
    required this.planNameAr,
    required this.planNameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.priceMonthly,
    required this.currency,
    required this.isActive,
    required this.offersLimit,
    required this.priorityLevel,
    required this.supportLevel,
  });

  factory PointOfferModel.fromJson(Map<String, dynamic> json) => PointOfferModel(
    planId: json["plan_Id"] as int? ?? 0,
    planNameAr: json["plan_Name_Ar"] as String? ?? "",
    planNameEn: json["plan_Name_En"] as String? ?? "",
    descriptionAr: json["description_Ar"] as String? ?? "",
    descriptionEn: json["description_En"] as String? ?? "",
    priceMonthly: (json["price_Monthly"] as num?)?.toDouble() ?? 0.0,
    currency: json["currency"] as String? ?? "",
    isActive: json["is_Active"] as bool? ?? false,
    offersLimit: json["offers_Limit"] as int? ?? 0,
    priorityLevel: json["priority_Level"] as int? ?? 0,
    supportLevel: json["support_Level"] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "plan_Id": planId,
    "plan_Name_Ar": planNameAr,
    "plan_Name_En": planNameEn,
    "description_Ar": descriptionAr,
    "description_En": descriptionEn,
    "price_Monthly": priceMonthly,
    "currency": currency,
    "is_Active": isActive,
    "offers_Limit": offersLimit,
    "priority_Level": priorityLevel,
    "support_Level": supportLevel,
  };
}
*/
