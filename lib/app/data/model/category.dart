class CategoryModel {
  final int id;
  final String categoryNameAr;
  final String categoryNameEn;

  CategoryModel({
    required this.id,
    required this.categoryNameAr,
    required this.categoryNameEn,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["category_Id"] as int? ?? 0,
        categoryNameAr: json["category_Name_Ar"] as String? ?? "",
        categoryNameEn: json["category_Name_En"] as String? ?? "",
      );

  Map<String, dynamic> toJson() => {
        "category_Id": id,
        "category_Name_Ar": categoryNameAr,
        "category_Name_En": categoryNameEn,
      };

  String get name {
    return categoryNameAr;
  }
}
