import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_viewmodel.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/model/contractor_detailed_model.dart';
import '../../../../gobal_controllers/user_controller.dart';
import '../../contractor_profile_details/controllers/contractor_profile_details_controller.dart';

class ContractorEditProfileController extends BaseController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController facebookController;
  late final TextEditingController xController;
  late final TextEditingController linkedinController;
  late final TextEditingController instagramController;

  final RxBool saving = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final contractorDetails = Rxn<ContractorDetailedModel>();

  @override
  void onInit() {
    super.onInit();
    facebookController = TextEditingController();
    xController = TextEditingController();
    linkedinController = TextEditingController();
    instagramController = TextEditingController();
    fetchContractorDetails();
  }

  @override
  void onClose() {
    facebookController.dispose();
    xController.dispose();
    linkedinController.dispose();
    instagramController.dispose();
    super.onClose();
  }

  Future<void> fetchContractorDetails() async {
    isLoading.value = true;
    hasError.value = false;

    final uid = Get.find<UserController>().user()!.id;
    final failureOrSuccess = await UserServices.getContractorDetails(uid);

    isLoading.value = false;
    failureOrSuccess.fold(
      (failure) {
        hasError.value = true;
        handleError(failure, fetchContractorDetails);
      },
      (details) {
        contractorDetails.value = details;
        facebookController.text = details.facebookLink;
        xController.text = details.xLink;
        linkedinController.text = details.linkedinLink;
        instagramController.text = details.instagramLink;
      },
    );
  }

  Future<void> saveProfile() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    saving(true);

    final details = contractorDetails.value;
    if (details == null) {
      saving(false);
      appSnackbar(AppStrings.defaultError.tr);
      return;
    }

    final result = await UserServices.updateProfile(
      contractorId: details.contractorId.isNotEmpty
          ? details.contractorId
          : Get.find<UserController>().user()!.id,
      fullName: details.fullName,
      emailContact: details.emailContact,
      experiancDes: details.experiancDes,
      facebookLink: facebookController.text.trim(),
      whatsappLink: details.whatsappLink,
      snapchatLink: details.snapchatLink,
      tiktokLink: details.tiktokLink,
      instagramLink: instagramController.text.trim(),
      linkedinLink: linkedinController.text.trim(),
      xLink: xController.text.trim(),
      email: details.email,
    );

    saving(false);
    result.fold(
      (failure) {
        handleError(failure, saveProfile);
      },
      (_) {
        if (Get.isRegistered<ContractorProfileDetailsController>()) {
          Get.find<ContractorProfileDetailsController>()
              .fetchContractorDetails();
        }
        Get.back();

        appSnackbar(AppStrings.profileUpdatedSuccessfully.tr,
            type: SnackbarType.SUCCESS);
      },
    );
  }
}
