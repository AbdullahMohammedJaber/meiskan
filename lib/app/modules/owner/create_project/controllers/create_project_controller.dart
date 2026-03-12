import 'package:app/app/config/routes/app_pages.dart';
import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:app/app/modules/owner/owner_dashboard/controllers/owner_dashboard_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/model/category.dart';
import '../../../../services/category_services.dart';
import '../../../../services/project_services.dart';

class CreateProjectController extends BaseController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  Map<String, List<String>> kuwaitLocations = {
  "محافظة العاصمة": [
    "القبلة",
    "المرقاب",
    "الصالحية",
    "شرق",
    "الدسمة",
    "الدعية",
    "العديلية",
    "الخالدية",
    "القادسية",
    "كيفان",
    "المنصورية",
    "النزهة",
    "الشامية",
    "الروضة",
    "الفيحاء",
    "قرطبة",
    "السرة",
    "اليرموك",
    "بنيد القار",
    "الشويخ",
    "الشويخ الصناعية", 
    "الشويخ السكنية"
  ],

  "محافظة حولي": [
    "حولي",
    "السالمية",
    "الرميثية",
    "الجابرية",
    "بيان",
    "مشرف",
    "الشهداء",
    "البدع",
    "سلوى",
    "الزهراء",
    "الصديق",
    "حطين",
    "السلام",
    "النقرة",
    "ميدان حولي"
  ],

  "محافظة الفروانية": [
    "الفروانية",
    "خيطان",
    "العمرية",
    "العارضية",
    "العارضية الصناعية",
    "العارضية الحرفية",
    "جليب الشيوخ",
    "الرابية",
    "الرحاب",
    "الأندلس",
    "إشبيلية",
    "الضجيج",
    "عبدالله المبارك",
    "الفردوس"
  ],

  "محافظة الأحمدي": [
    "الأحمدي",
    "الفحيحيل",
    "المنقف",
    "أبو حليفة",
    "الرقة",
    "هدية",
    "الصباحية",
    "العقيلة",
    "أبو فطيرة",
    "المهبولة",
    "الوفرة",
    "الزور",
    "الخيران",
    "بنيدر",
    "المقوع",
    "وارة"
  ],

  "محافظة الجهراء": [
    "الجهراء",
    "النسيم",
    "تيماء",
    "القصر",
    "العيون",
    "الواحة",
    "النعيم",
    "النسيم الجديدة",
    "العبدلي",
    "الصليبية",
    "كبد"
  ],

  "محافظة مبارك الكبير": [
    "مبارك الكبير",
    "القرين",
    "القصور",
    "العدان",
    "صباح السالم",
    "المسيلة",
    "أبو الحصانية",
    "صبحان"
  ],
};
  RxString selectedGovernorate = ''.obs;
  RxString selectedArea = ''.obs;

  List<String> get governorates => kuwaitLocations.keys.toList();

  List<String> get areas => kuwaitLocations[selectedGovernorate.value] ?? [];

  void onGovernorateChanged(String value) {
    selectedGovernorate.value = value;
    selectedArea.value = '';
    addressController.text = value;
    areaController.clear();
  }

  void onAreaChanged(String value) {
    selectedArea.value = value;
    areaController.text = value;
  }

  // Observable variables
  RxBool loading = false.obs;
  RxString selectedProjectCategory = ''.obs;
  RxInt selectedCategoryId = 0.obs;
  RxList<String> selectedImages = <String>[].obs;
  RxnString selectedFile = RxnString(null);
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxBool categoriesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    categoriesLoading(true);
    try {
      final result = await CategoryServices.getCategories();
      result.fold(
        (failure) => handleError(failure, loadCategories),
        (loadedCategories) {
          categories.assignAll(loadedCategories);
        },
      );
    } catch (e) {
      appSnackbar(AppStrings.errorOccurred.tr, type: SnackbarType.ERROR);
    } finally {
      categoriesLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    projectTitleController.dispose();
    projectDescriptionController.dispose();
    noteController.dispose();
    areaController.dispose();
    cityController.dispose();
    addressController.dispose();
  }

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        limit: 4,
      );

      if (images.isEmpty) return;

      final int remaining = 4 - selectedImages.length;

      if (remaining <= 0) {
        appSnackbar(
          "يمكنك رفع 4 صور فقط",
          type: SnackbarType.ERROR,
        );
        return;
      }

      if (images.length > remaining) {
        appSnackbar(
          AppStrings.errorSelectingImages.tr,
          type: SnackbarType.ERROR,
        );
      }

      selectedImages.addAll(
        images.take(remaining).map((e) => e.path),
      );
    } catch (e) {
      appSnackbar(
        AppStrings.errorSelectingImages.tr,
        type: SnackbarType.ERROR,
      );
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'png'],
      );

      if (result != null) {
        for (PlatformFile file in result.files) {
          selectedFile(file.path);
        }
      }
    } catch (e) {
      appSnackbar(AppStrings.errorSelectingFiles.tr, type: SnackbarType.ERROR);
    }
  }

  void removeFile() {
    selectedFile(null);
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (selectedProjectCategory.value.isEmpty) {
      appSnackbar(AppStrings.pleaseSelectProjectCategory.tr,
          type: SnackbarType.ERROR);
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      appSnackbar(AppStrings.city.tr, type: SnackbarType.ERROR);
      return false;
    }

    if (areaController.text.trim().isEmpty) {
      appSnackbar(AppStrings.area.tr, type: SnackbarType.ERROR);
      return false;
    }
    if (selectedImages.isEmpty) {
      appSnackbar("الرجاء اختيار صور للمشروع لا تزيد عن 4 صور",
          type: SnackbarType.ERROR);
      return false;
    }

    return true;
  }

  Future<void> create() async {
    if (!_validateForm()) return;

    loading(true);

    int categoryId = 0;
    for (var category in categories) {
      if (category.name == selectedProjectCategory.value) {
        categoryId = category.id;
        break;
      }
    }

    List<dio.MultipartFile>? imageFiles = [];
    for (String imagePath in selectedImages) {
      imageFiles.add(await dio.MultipartFile.fromFile(imagePath));
    }

    // Call the create project service
    final result = await ProjectServices.createProject(
      projectTitle: projectTitleController.text.trim(),
      projectDescription: projectDescriptionController.text.trim(),
      cityName: cityController.text.trim(),
      areaName: areaController.text.trim(),
      address: addressController.text.trim(),
      categoryId: categoryId.toString(),
      note: noteController.text.trim(),
      images: imageFiles,
      pdfFile: selectedFile.value == null
          ? null
          : await dio.MultipartFile.fromFile(selectedFile.value!),
      ownerId: Get.find<UserController>().user()!.id.toString(),
    );
    loading(false);

    result.fold(
      (failure) {
        appSnackbar(failure.message ?? AppStrings.failedToCreateProject.tr,
            type: SnackbarType.ERROR);
      },
      (projectId) async {
        appSnackbar(AppStrings.projectAddedSuccessfully.tr,
            type: SnackbarType.SUCCESS);
        final dashboardController = Get.find<OwnerDashboardController>();
        await dashboardController.fetchProjects(refresh: true);
        await dashboardController.fetchStatistics();
        Get.offAllNamed(Routes.OWNER_DASHBOARD);
      },
    );
  }
}
