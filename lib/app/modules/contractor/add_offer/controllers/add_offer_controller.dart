import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/data/model/detailed_project.dart';
import 'package:app/app/services/offer_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/strings_manager.dart';

class AddOfferController extends BaseController {
  final formKey = GlobalKey<FormState>();
  late DetailedProjectModel projectDetails;

  final offerPriceController = TextEditingController();
  final offerDurationController = TextEditingController();
  final offerDescriptionController = TextEditingController();

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the project details passed as arguments
    projectDetails = Get.arguments as DetailedProjectModel;
  }

  @override
  void onClose() {
    offerPriceController.dispose();
    offerDurationController.dispose();
    offerDescriptionController.dispose();
    super.onClose();
  }

  Future<void> submitOffer() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    loading.value = true;

    final offerPrice = double.tryParse(offerPriceController.text) ?? 0.0;
    final offerDuration = int.tryParse(offerDurationController.text) ?? 0;
    final offerDescription = offerDescriptionController.text;
    final projectId = projectDetails.projectId;
    final result = await OfferServices.createOffer(
      projectId: projectId,
      offerDescription: offerDescription,
      offerDuration: offerDuration,
      offerPrice: offerPrice,
    );
    loading.value = false;

    result.fold(
      (failure) => handleError(failure, submitOffer),
      (_) {
        Get.back(result: true);
        appSnackbar(AppStrings.offerAddedSuccessfully.tr);
      },
    );
  }
}
