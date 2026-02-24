import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/data/model/project.dart';
import 'package:app/app/data/model/statistics_data.dart';
import 'package:app/app/services/project_services.dart';
import 'package:app/app/services/statistics_services.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContractorDashboardController extends BaseController {
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

  final searchTextController = TextEditingController();
  // Projects observables
  final projects = <ProjectModel>[].obs;
  final projectsHasError = false.obs;
  final projectsIsLoading = false.obs;
  final projectsCurrentPage = 0.obs;
  final projectsHasMoreData = true.obs;
  final searchViaText = false.obs;
  final projectsPerPage = 10;

  // Filter properties
  final RxString selectedCategory = ''.obs;
  final RxString selectedProvince = ''.obs;
  final RxString selectedRegion = ''.obs;
  final RxString searchText = ''.obs;

  bool _searchTextUsed = false;

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
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

  Future<void> fetchProjects({bool refresh = false}) async {
    _searchTextUsed = searchText.isNotEmpty;
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
      categoryId:
          selectedCategory.value.isEmpty ? null : selectedCategory.value,
      cityName: selectedProvince.value.isEmpty ? null : selectedProvince.value,
      areaName: selectedRegion.value.isEmpty ? null : selectedRegion.value,
      searchValue: searchText.isEmpty ? null : searchText.trim(),
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

  void applyFilters(Map<String, dynamic> filters) {
    selectedCategory.value = filters['category'] ?? '';
    selectedProvince.value = filters['province'] ?? '';
    selectedRegion.value = filters['region'] ?? '';

    fetchProjects(refresh: true);
  }

  void clearFilters() {
    selectedCategory.value = '';
    selectedProvince.value = '';
    selectedRegion.value = '';
    fetchProjects(refresh: true);
  }

  void clearSearch() {
    searchText('');
    searchTextController.clear();
    if (_searchTextUsed) fetchProjects(refresh: true);
  }
}
