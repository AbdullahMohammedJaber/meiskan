import 'package:app/app/core/constants.dart';

class ProjectModel {
  final String projectId;
  final String projectTitle;
  final String image;
  final String categoryNameAr;
  final String categoryNameEn;
  final String projectDescription;
  final String cityName;
   final String areaName;
  final String address;
  final DateTime dateAdded;
  final bool projectStatus;
  final bool projectType;
  final bool isLocked;
  final int offersNumber;

  ProjectModel({
    required this.projectId,
    required this.projectTitle,
    required this.image,
    required this.isLocked,
    required this.categoryNameAr,
    required this.categoryNameEn,
    required this.projectDescription,
    required this.cityName,
    required this.areaName,
     required this.address,
    required this.dateAdded,
    required this.projectStatus,
    required this.projectType,
    required this.offersNumber,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    projectId: json["project_Id"] as String? ?? "",
    image: '${Constants.baseUrl}ProjectImg/${json["image"] as String? ?? ""}',
     projectTitle: json["project_Title"] as String? ?? "",
    categoryNameAr: json["category_Name_Ar"] as String? ?? "",
    categoryNameEn: json["category_Name_En"] as String? ?? "",
    projectDescription: json["project_Description"] as String? ?? "",
    cityName: json["city_Name"] as String? ?? "",
     areaName: json["area_Name"] as String? ?? "",
    address: json["address"] as String? ?? "",
    dateAdded: DateTime.tryParse(json["date_Added"] ?? "") ?? DateTime.now(),
    projectStatus: json["project_Status"] as bool? ?? false,
    isLocked: json["is_Locked"] as bool? ?? false,
    projectType: json["project_Type"] as bool? ?? false,
    offersNumber: json["offers_Number"] as int? ?? 0,
  );


}
