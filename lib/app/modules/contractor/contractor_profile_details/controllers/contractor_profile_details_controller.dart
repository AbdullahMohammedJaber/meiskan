import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/utils/app_snackbar.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/services/job_services.dart';
import 'package:app/app/services/plan_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/model/contractor_detailed_model.dart';
import '../../../../gobal_controllers/user_controller.dart';
import '../../../../services/user_services.dart';

class ContractorProfileDetailsController extends BaseController {
  RxInt selectedTabIndex = 0.obs;

  final contractorDetailed = Rxn<ContractorDetailedModel>();
  final isLoading = true.obs;
  final hasError = false.obs;
  final isCancelingPlan = false.obs;
  final isAddingJob = false.obs;

  String? contractorId;

  @override
  void onInit() {
    super.onInit();
    fetchContractorDetails();
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
        handleError(failure, () => fetchContractorDetails());
      },
      (contractorDetails) {
        contractorDetailed.value = contractorDetails;
      },
    );
  }

  Future addJob({
    required XFile image,
    required String companyName,
    required String location,
    required String description,
  }) async {
    final contractorId = Get.find<UserController>().user()?.id;
    if (contractorId == null) return;

    isAddingJob.value = true;

    final result = await JobServices.createJob(
      contractorId: contractorId,
      companyName: companyName,
      location: location,
      descriptionAr: description,
      descriptionEn: description,
      image: image,
    );
    isAddingJob.value = false;

    result.fold(
      (failure) {
        appSnackbar(failure.message);

        handleError(
          failure,
          () => addJob(
            image: image,
            companyName: companyName,
            location: location,
            description: description,
          ),
        );
      },
      (_) {
        Get.back();
        appSnackbar(AppStrings.jobAddedSuccessfully.tr);
        fetchContractorDetails();
      },
    );
  }

  cancelPlan() async {
    isCancelingPlan.value = true;

    final result = await PlanServices.cancelPlanById(
        contractorDetailed()!.subscription!.subscripeId);
    isCancelingPlan.value = false;

    result.fold(
      (failure) {
        handleError(failure, cancelPlan);
      },
      (_) {
        appSnackbar(AppStrings.planCanceledSuccessfully.tr);
        fetchContractorDetails();
      },
    );
  }
}
