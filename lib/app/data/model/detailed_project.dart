import '../../core/constants.dart';
import 'offer.dart';

class DetailedProjectModel {
  final String projectId;
  final int categoryId;
  final String categoryNameAr;
  final String categoryNameEn;
  final String projectDescription;
  final String cityName;
  final String areaName;
  final String address;
  final String ownerId;
  final String note;
  final String? fileName;
  final bool projectStatus;
  final DateTime dateAdded;
  final int offersNumber;
  final List<ProjectImage> images;
  final List<ProjectOffer> offers;

  DetailedProjectModel({
    required this.projectId,
    required this.categoryId,
    required this.categoryNameAr,
    required this.categoryNameEn,
    required this.projectDescription,
    required this.ownerId,
    required this.cityName,
    required this.areaName,
    required this.address,
    required this.note,
    required this.fileName,
    required this.projectStatus,
    required this.dateAdded,
    required this.offersNumber,
    required this.images,
    required this.offers,
  });

  factory DetailedProjectModel.fromJson(Map<String, dynamic> json) =>
      DetailedProjectModel(
        projectId: json["project_Id"] as String? ?? "",
        categoryId: json["category_Id"] as int? ?? 0,
        ownerId: json["owner_Id"] as String? ?? '',

        categoryNameAr: json["category_Name_Ar"] as String? ?? "",
        categoryNameEn: json["category_Name_En"] as String? ?? "",
        projectDescription: json["project_Description"] as String? ?? "",
        cityName: json["city_Name"] as String? ?? "",
        areaName: json["area_Name"] as String? ?? "",
        address: json["address"] as String? ?? "",
        note: json["note"] as String? ?? "",
        fileName: json["file_Name"] as String?,
        projectStatus: json["project_Status"] as bool? ?? false,
        dateAdded:
            DateTime.tryParse(json["date_Added"] ?? "") ?? DateTime.now(),
        offersNumber: json["offers_Number"] as int? ?? 0,
        images: (json["images"] as List<dynamic>?)
                ?.map((e) => ProjectImage.fromJson(e))
                .toList() ??
            [],
        offers: (json["offers"] as List<dynamic>?)
                ?.map((e) => ProjectOffer.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "project_Id": projectId,
        "category_Id": categoryId,
        "category_Name_Ar": categoryNameAr,
        "category_Name_En": categoryNameEn,
        "project_Description": projectDescription,
        "city_Name": cityName,
        "area_Name": areaName,
        "address": address,
        "note": note,
        "file_Name": fileName,
        "project_Status": projectStatus,
        "date_Added": dateAdded.toIso8601String(),
        "offers_Number": offersNumber,
        "images": images.map((e) => e.toJson()).toList(),
        "offers": offers.map((e) => e.toJson()).toList(),
      };

  DetailedProjectModel copyWith({
    String? projectId,
    int? categoryId,
    String? categoryNameAr,
    String? categoryNameEn,
    String? projectDescription,
    String? cityName,
    String? areaName,
    String? address,
    String? ownerId,
    String? note,
    String? fileName,
    bool? projectStatus,
    DateTime? dateAdded,
    int? offersNumber,
    List<ProjectImage>? images,
    List<ProjectOffer>? offers,
  }) {
    return DetailedProjectModel(
      projectId: projectId ?? this.projectId,
      categoryId: categoryId ?? this.categoryId,
      categoryNameAr: categoryNameAr ?? this.categoryNameAr,
      categoryNameEn: categoryNameEn ?? this.categoryNameEn,
      projectDescription: projectDescription ?? this.projectDescription,
      ownerId: ownerId ?? this.ownerId,
      cityName: cityName ?? this.cityName,
      areaName: areaName ?? this.areaName,
      address: address ?? this.address,
      note: note ?? this.note,
      fileName: fileName ?? this.fileName,
      projectStatus: projectStatus ?? this.projectStatus,
      dateAdded: dateAdded ?? this.dateAdded,
      offersNumber: offersNumber ?? this.offersNumber,
      images: images ?? this.images,
      offers: offers ?? this.offers,
    );
  }

  String? get fileUrl {
    if (fileName == null || fileName!.isEmpty) return null;
    return "${Constants.baseUrl}files/$fileName";
  }
}

class ProjectImage {
  final int imageId;
  final String imagePath;
  final String projectId;

  ProjectImage({
    required this.imageId,
    required this.imagePath,
    required this.projectId,
  });

  factory ProjectImage.fromJson(Map<String, dynamic> json) => ProjectImage(
        imageId: json["image_Id"] as int? ?? 0,
        imagePath: json["image_Path"] as String? ?? "",
        projectId: json["project_Id"] as String? ?? "",
      );

  Map<String, dynamic> toJson() => {
        "image_Id": imageId,
        "image_Path": imagePath,
        "project_Id": projectId,
      };

  String get url => "${Constants.baseUrl}ProjectImg/$imagePath";
}
