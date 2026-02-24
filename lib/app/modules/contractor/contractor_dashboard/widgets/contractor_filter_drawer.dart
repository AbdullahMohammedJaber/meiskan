import 'package:app/app/core/utils/colors_manager.dart';
import 'package:app/app/core/utils/kw.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/modules/contractor/contractor_dashboard/controllers/contractor_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../contractor_home/controllers/contractor_home_controller.dart';

class ContractorFilterDrawer extends StatefulWidget {
  const ContractorFilterDrawer({super.key});

  @override
  State<ContractorFilterDrawer> createState() => _ContractorFilterDrawerState();
}

class _ContractorFilterDrawerState extends State<ContractorFilterDrawer> {
  int? _selectedCategory;
  int? _selectedProvince;
  int? _selectedRegion;

  final RxList<String> _provinces = <String>[].obs;
  final RxList<String> _regions = <String>[].obs;

  final contractorDashboardController =
      Get.find<ContractorDashboardController>();
  final contractorHomeController = Get.find<ContractorHomeController>();

  @override
  void initState() {
    super.initState();
    _provinces.assignAll(KwLocations.provinces);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      contractorHomeController.getCategories();
    });

    _initializeFromController();
  }

  void _initializeFromController() {
    // Initialize category
    if (contractorDashboardController.selectedCategory.value.isNotEmpty) {
      final categoryIndex = contractorHomeController.categories.indexWhere(
          (category) =>
              category.id.toString() ==
              contractorDashboardController.selectedCategory.value);
      if (categoryIndex != -1) {
        _selectedCategory = categoryIndex;
      }
    }

    // Initialize province
    if (contractorDashboardController.selectedProvince.value.isNotEmpty) {
      final provinceIndex = _provinces
          .indexOf(contractorDashboardController.selectedProvince.value);
      if (provinceIndex != -1) {
        _selectedProvince = provinceIndex;

        // Update regions list based on selected province
        final regions = KwLocations.getRegionsForProvince(
            contractorDashboardController.selectedProvince.value);
        _regions.assignAll(regions);

        if (contractorDashboardController.selectedRegion.value.isNotEmpty) {
          final regionIndex = _regions
              .indexOf(contractorDashboardController.selectedRegion.value);
          if (regionIndex != -1) {
            _selectedRegion = regionIndex;
          }
        }
      }
    }
  }

  void _onProvinceSelected(int index) {
    setState(() {
      _selectedProvince = index;
      _selectedRegion = null; // Reset region when province changes
      // Update regions list based on selected province
      if (index < _provinces.length) {
        final selectedProvinceName = _provinces[index];
        final regions = KwLocations.getRegionsForProvince(selectedProvinceName);
        _regions.assignAll(regions);
      } else {
        _regions.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      width: MediaQuery.of(context).size.width * 0.9,
      elevation: 16,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() => contractorHomeController.categoriesLoading.value
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : _buildSection(
                              title: AppStrings.projectCategory.tr,
                              options: contractorHomeController.categories
                                  .map((category) => category.name)
                                  .toList(),
                              selectedIndex: _selectedCategory,
                              onSelected: (index) =>
                                  setState(() => _selectedCategory = index),
                            )),
                      Divider(height: 40.h),
                      _buildSection(
                        title: AppStrings.province.tr,
                        options: _provinces,
                        selectedIndex: _selectedProvince,
                        onSelected: _onProvinceSelected,
                      ),
                      Divider(height: 40.h),
                      Obx(() => _buildSection(
                            title: AppStrings.region.tr,
                            options: _regions,
                            selectedIndex: _selectedRegion,
                            onSelected: (index) =>
                                setState(() => _selectedRegion = index),
                          )),
                    ],
                  ),
                ),
              ),
              32.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          final result = {
                            'category': _selectedCategory != null &&
                                    _selectedCategory! <
                                        contractorHomeController
                                            .categories.length
                                ? contractorHomeController
                                    .categories[_selectedCategory!].id
                                    .toString()
                                : null,
                            'province': _selectedProvince != null &&
                                    _selectedProvince! < _provinces.length
                                ? _provinces[_selectedProvince!]
                                : null,
                            'region': _selectedRegion != null &&
                                    _selectedRegion! < _regions.length
                                ? _regions[_selectedRegion!]
                                : null,
                          };

                          Get.back();
                          Get.find<ContractorHomeController>()
                              .applyFilters(result);
                        },
                        child: Container(
                          height: 46.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.r),
                            color: AppColors.primaryColor,
                          ),
                          child: Text(
                            AppStrings.apply.tr,
                            style: Get.textTheme.bodyMedium!.copyWith(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          Get.back();
                          _selectedCategory = null;
                          _selectedProvince = null;
                          _selectedRegion = null;

                          contractorDashboardController.clearFilters();

                          _initializeFromController();
                        }),
                        child: Container(
                          height: 46.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.r),
                            border: Border.all(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          child: Text(
                            AppStrings.resetFilters.tr,
                            style: Get.textTheme.bodyMedium!.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.textColor,
                      iconSize: 20.sp,
                      splashRadius: 20.r,
                      onPressed: Get.back),
                ],
              ),
            ),
            Text(
              AppStrings.filterResults.tr,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
            ),
            const Spacer(),
          ],
        ),
      );

  Widget _buildSection({
    required String title,
    required List<String> options,
    required int? selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
            ),
          ),
          10.verticalSpace,
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(options.length, (index) {
              final isSelected = selectedIndex == index;
              return SizedBox(
                child: GestureDetector(
                  onTap: () => onSelected(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 29.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xffDDEBE8)
                          : const Color(0xffF1F2F2),
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xff3A8577).withOpacity(0.2)
                            : AppColors.inputBorderColor,
                      ),
                    ),
                    child: Text(
                      options[index],
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color:
                            isSelected ? AppColors.textColor : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
