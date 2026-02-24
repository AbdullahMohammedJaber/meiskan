import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/data/model/contractor_detailed_model.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:app/app/services/user_services.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class ContractorRatingsController extends BaseController {
  final contractorDetailed = Rxn<ContractorDetailedModel>();
  final isLoading = true.obs;
  final hasError = false.obs;

  String? contractorId;

  @override
  void onInit() {
    super.onInit();
    fetchContractorDetailsById();
  }

  Future<void> fetchContractorDetailsById() async {
    isLoading.value = true;
    hasError.value = false;

    final uid = Get.find<UserController>().user()!.id;
    Either failureOrSuccess = await UserServices.getContractorDetails(uid);

    isLoading.value = false;
    failureOrSuccess.fold(
      (failure) {
        hasError.value = true;
        handleError(failure, () => fetchContractorDetailsById());
      },
      (contractorDetails) {
        contractorDetailed.value = contractorDetails;
      },
    );
  }
}
