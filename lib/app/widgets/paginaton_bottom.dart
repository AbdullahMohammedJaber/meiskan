import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/enums/enums.dart';
import '../core/utils/strings_manager.dart';

class PaginationBottomWidget extends StatelessWidget {
  final Status status;


  const PaginationBottomWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: status == Status.loading,
      replacement: Visibility(
        visible: status == Status.noMore,
        child: _noMoreWidget(),
      ),
      child: _loadingWidget(),
    );
  }

  Widget _loadingWidget() => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: const CircularProgressIndicator(),
      );

  Widget _noMoreWidget() => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          AppStrings.noMoreProperties.tr,
          style: Get.textTheme.bodyMedium,
        ),
      );
}
