import 'package:app/app/core/constants.dart';
import 'package:app/app/data/model/rate.dart';
import 'package:get/get.dart';

import 'job.dart';
import 'offer.dart';
import 'transaction.dart';

class ContractorDetailedModel {
  final bool isActive;
  final String fullName;
  final String? imageUrl;
  final String emailContact;
  final String experiancDes;
  final String facebookLink;
  final String whatsappLink;
  final String snapchatLink;
  final String tiktokLink;
  final String instagramLink;
  final String linkedinLink;
  final String xLink;
  final String phoneNumber;
  final String email;
  final int pointsNumber;
  final int ballanceOffers;
  final Subscription? subscription;
  final String contractorId;
  final double rateStars;
  final List<RatingModel> ratings;
  final List<ProjectOffer> offers;
  final List<JobModel> jobs;
  final List<TransactionModel> transactions;

  ContractorDetailedModel({
    required this.ballanceOffers,
    required this.isActive,
    required this.fullName,
    required this.subscription,
    required this.imageUrl,
    required this.emailContact,
    required this.experiancDes,
    required this.facebookLink,
    required this.whatsappLink,
    required this.snapchatLink,
    required this.tiktokLink,
    required this.instagramLink,
    required this.linkedinLink,
    required this.xLink,
    required this.phoneNumber,
    required this.email,
    required this.pointsNumber,
    required this.contractorId,
    required this.rateStars,
    required this.ratings,
    required this.offers,
    required this.jobs,
    required this.transactions,
  });

  factory ContractorDetailedModel.fromJson(Map<String, dynamic> json) {
    return ContractorDetailedModel(
      isActive: json["is_Active"] as bool? ?? false,
      subscription: json["subscripe"] == null
          ? null
          : Subscription.fromJson(json["subscripe"] as Map<String, dynamic>),
      fullName: json["full_Name"] as String? ?? "",
      imageUrl: (() {
        final imageValue = (json["image_Url"] ?? json["image_Name"] ?? "") as String;
        if (imageValue.isEmpty) {
          return null;
        }
        return '${Constants.appName}$imageValue';
      })(),
      emailContact: json["email_Contact"] as String? ?? "",
      experiancDes: json["experianc_Des"] as String? ?? "",
      facebookLink: json["facebook_Link"] as String? ?? "",
      whatsappLink: json["whatsapp_Link"] as String? ?? "",
      snapchatLink: json["snapchat_Link"] as String? ?? "",
      tiktokLink: json["tiktok_Link"] as String? ?? "",
      instagramLink: json["instagram_Link"] as String? ?? "",
      linkedinLink: json["linkedin_Link"] as String? ?? "",
      xLink: json["x_Link"] as String? ?? "",
      phoneNumber: json["phone_Number"] as String? ?? "",
      email: json["email"] as String? ?? "",
      pointsNumber: json["points_Number"] as int? ?? 0,
      ballanceOffers: json["ballance_Offers"] as int? ?? 0,
      contractorId: json["contractor_Id"] as String? ?? "",
      rateStars: (json["rate_Stars"] as num? ?? 0).toDouble(),
      ratings: (json["ratings"] as List<dynamic>? ?? [])
          .map((e) => RatingModel.fromJson(e))
          .toList(),
      offers: (json["offers"] as List<dynamic>? ?? [])
          .map((e) => ProjectOffer.fromJson(e))
          .toList(),
      jobs: (json["jobs"] as List<dynamic>? ?? [])
          .map((e) => JobModel.fromJson(e))
          .toList(),
      transactions: (json["transactions"] as List<dynamic>? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
    );
  }
}

class Subscription {
  final int subscripeId;
  final DateTime startDate;
  final int status;
  final DateTime nextBillingDate;
  final DateTime? canceledAt;
  final int planId;
  final String planeNameAr;
  final String planeNameEn;
  final double priceMonthly;
  final int offersLimit;
  final int priorityLevel;
  final int supportLevel;
  final int remainingOffers;
  final String? userId;
  final String? userName;
  final String? phoneNumber;

  Subscription({
    required this.subscripeId,
    required this.startDate,
    required this.status,
    required this.nextBillingDate,
    this.canceledAt,
    required this.planId,
    required this.planeNameAr,
    required this.planeNameEn,
    required this.priceMonthly,
    required this.offersLimit,
    required this.priorityLevel,
    required this.supportLevel,
    required this.remainingOffers,
    this.userId,
    this.userName,
    this.phoneNumber,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      subscripeId: json["subscripe_Id"] as int? ?? 0,
      startDate: DateTime.parse(
          json["start_Date"] as String? ?? DateTime.now().toIso8601String()),
      status: json["status"] as int? ?? 0,
      nextBillingDate: DateTime.parse(json["next_Billing_Date"] as String? ??
          DateTime.now().toIso8601String()),
      canceledAt: json["canceled_At"] == null
          ? null
          : DateTime.parse(json["canceled_At"] as String),
      planId: json["plan_Id"] as int? ?? 0,
      planeNameAr: json["plane_Name_Ar"] as String? ?? "",
      planeNameEn: json["plane_Name_En"] as String? ?? "",
      priceMonthly: (json["price_Monthly"] as num? ?? 0).toDouble(),
      offersLimit: json["offers_Limit"] as int? ?? 0,
      priorityLevel: json["priority_Level"] as int? ?? 0,
      supportLevel: json["support_Level"] as int? ?? 0,
      remainingOffers: json["remaining_Offers"] as int? ?? 0,
      userId: json["user_Id"] as String?,
      userName: json["user_Name"] as String?,
      phoneNumber: json["phone_Number"] as String?,
    );
  }

  String get planName {
    final language = Get.locale?.languageCode ?? 'en';
    if (language == 'ar') {
      return planeNameAr;
    } else {
      return planeNameEn;
    }
  }
}
