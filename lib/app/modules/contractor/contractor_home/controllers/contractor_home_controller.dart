import 'package:app/app/core/base/base_viewmodel.dart';
import 'package:app/app/data/model/category.dart';
import 'package:app/app/modules/contractor/contractor_dashboard/views/contractor_dashboard_view.dart';
import 'package:app/app/modules/notifications/views/notifications_view.dart';
import 'package:app/app/services/category_services.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contractor_dashboard/controllers/contractor_dashboard_controller.dart';
import '../../contractor_profile/views/contractor_profile_view.dart';

class ContractorHomeController extends BaseController {
  RxInt selectedIndex = 0.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final pages = const [
    ContractorDashboardView(),
    NotificationsView(showAppBar: false),
    ContractorProfileView(),
  ];

  // Categories observables
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool categoriesLoading = true.obs;

  // Apply filters to the dashboard controller
  void applyFilters(Map<String, dynamic> filters) {
    final dashboardController = Get.find<ContractorDashboardController>();
    dashboardController.applyFilters(filters);
  }

  // Clear filters in the dashboard controller
  void clearFilters() {
    final dashboardController = Get.find<ContractorDashboardController>();
    dashboardController.clearFilters();
  }

  getCategories() async {
    if (categories.isNotEmpty) return Right(categories);
    categoriesLoading.value = true;
    final result = await CategoryServices.getCategories();
    result.fold(
      (failure) => handleError(failure, getCategories),
      (categoryList) {
        categories.assignAll(categoryList);
      },
    );
    categoriesLoading.value = false;
  }
}
