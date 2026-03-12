import 'package:app/app/core/base/base_viewmodel.dart';

import 'package:get/get.dart';

import '../../../../data/model/contractor_detailed_model.dart';
import '../../../../services/user_services.dart';

class ContractorProfileIdController extends BaseController {
  RxInt selectedTabIndex = 0.obs;

  final contractorDetailed = Rxn<ContractorDetailedModel>();
  final isLoading = true.obs;
  final hasError = false.obs;
  late String uId;
  @override
  void onInit() {
    super.onInit();
    uId = Get.parameters['id'] ?? '';
    if (uId.isNotEmpty) {
      fetchContractorDetails();
    }
  }

  Future<void> fetchContractorDetails() async {
    isLoading.value = true;
    hasError.value = false;

    final failureOrSuccess = await UserServices.getContractorDetails(uId);

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
}
