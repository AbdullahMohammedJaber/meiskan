import 'package:app/app/core/constants.dart';

class JobModel {
  final int jobId;
  final String image;
  final String descriptionAr;
  final String descriptionEn;
  final String companyName;
  final String location;
  final String contractorId;
  final dynamic user;

  JobModel({
    required this.jobId,
    required this.image,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.companyName,
    required this.location,
    required this.contractorId,
    this.user,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobId: json["job_Id"] as int? ?? 0,
      image:'${Constants.baseUrl}JobImg/${json["image"] as String? ?? ""}',
      descriptionAr: json["description_Ar"] as String? ?? "",
      descriptionEn: json["description_En"] as String? ?? "",
      companyName: json["company_Name"] as String? ?? "",
      location: json["location"] as String? ?? "",
      contractorId: json["contractor_Id"] as String? ?? "",
      user: json["user"], // could be null or nested object
    );
  }
  }
