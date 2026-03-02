import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/data/model/project.dart';
import 'package:app/app/data/model/statistics_data.dart';
import 'package:app/app/services/project_services.dart';
import 'package:app/app/services/statistics_services.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../gobal_controllers/user_controller.dart';

class OwnerDashboardController extends BaseController {
  // Statistics observables
  final statistics = StatisticsData(
    projects: 0,
    offers: 0,
    users: 0,
    remainingOffers: 0,
    rating: 0,
  ).obs;
  final statisticsHasError = false.obs;
  final statisticsIsLoading = false.obs;

  // Projects observables
 final projects = <ProjectModel>[].obs;
  final projectsHasError = false.obs;
  final projectsIsLoading = false.obs;
  final projectsCurrentPage = 0.obs;
  final projectsHasMoreData = true.obs;
  final projectsPerPage = 10;

  @override
  void onInit() {
    super.onInit();
    //fetchStatistics();
    fetchProjects(refresh: true);
  }

  // Statistics methods
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

  // Projects methods
  Future<void> fetchProjects({bool refresh = false}) async {
    if (refresh) {
      projectsCurrentPage.value = 1;
      projects.clear();
    } else if (!refresh && projectsCurrentPage.value == 0) {
      projectsCurrentPage.value = 1;
    }

    if (!refresh && !projectsHasMoreData.value) {
      return;
    }

    projectsIsLoading.value = true;
    projectsHasError.value = false;

    Either failureOrSuccess = await ProjectServices.getProjects(
      pageNumber: projectsCurrentPage.value,
      pageSize: projectsPerPage,
      ownerId: Get.find<UserController>().user.value?.id,
    );

    projectsIsLoading.value = false;
    failureOrSuccess.fold(
      (failure) {
        projectsHasError.value = true;
        handleError(failure, () => fetchProjects(refresh: refresh));
      },
      (fetchedProjects) {
        if (fetchedProjects.isEmpty) {
          projectsHasMoreData.value = false;
        } else {
          projects.addAll(fetchedProjects);
          projectsCurrentPage.value++;
          if (fetchedProjects.length < projectsPerPage) {
            projectsHasMoreData.value = false;
          }
        }
      },
    );
  }

  Future<void> loadMoreProjects() async {
    if (projectsHasMoreData.value && !projectsIsLoading.value) {
      await fetchProjects(refresh: false);
    }
  }

  Future onRefresh() async {
    await Future.wait([
      fetchStatistics(),
      fetchProjects(refresh: true),
    ]);
  }
}
