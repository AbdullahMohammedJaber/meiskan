import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/data/model/plan.dart';
import 'package:app/app/data/model/statistics_data.dart';
import 'package:app/app/services/plan_services.dart';
import 'package:app/app/services/statistics_services.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../gobal_controllers/user_controller.dart';

class HomeController extends BaseController {
  var plans = <PointOfferModel>[].obs;
  var isLoadingPlans = false.obs;
  final statistics = StatisticsData(
    projects: 0,
    offers: 0,
    users: 0,
    remainingOffers: 0,
    rating: 0,
  ).obs;
  final statisticsHasError = false.obs;
  final statisticsIsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
    getPlans();
  }

  Future<void> getPlans() async {
    final user = Get.find<UserController>().user();
    if (user?.type != AccountType.contractor) return;

    isLoadingPlans.value = true;
    final result = await PlanServices.getAllPlans();
    result.fold(
      (failure) => handleError(failure, getPlans),
      (fetchedPlans) {
        plans.assignAll(fetchedPlans);
      },
    );
    isLoadingPlans.value = false;
  }

  Future<void> fetchStatistics() async {
    statisticsIsLoading.value = true;
    statisticsHasError.value = false;

    Either failureOrSuccess = await StatisticsServices.getStatistics();

    statisticsIsLoading.value = false;
    failureOrSuccess.fold(
      (failure) {
        statisticsHasError.value = true;
        handleError(failure, () => fetchStatistics());
      },
      (fetchedStatistics) {
        statistics.value = fetchedStatistics;
      },
    );
  }
}
