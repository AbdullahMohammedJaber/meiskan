import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/data/model/job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'add_job_dialog.dart';

class ContractorPortfolioTab extends StatelessWidget {
  final List<JobModel> jobs;

  const ContractorPortfolioTab({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: () => _openAddJobDialog(),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: Row(
              children: [
                Text(
                  AppStrings.myProjects.tr,
                  style: Get.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(
                  AppIcons.addCircleOutlined,
                  width: 25.w,
                  height: 25.h,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                8.horizontalSpace,
                Text(
                  AppStrings.addProject.tr,
                  style: Get.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        10.verticalSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.w,
                mainAxisSpacing: 1.h,
              ),
              itemCount: jobs.length,
              itemBuilder: (_, index) {
                final job = jobs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    image: DecorationImage(
                        image: NetworkImage(job.image), fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _openAddJobDialog() {
    Get.dialog(
      const AddJobDialog(),
      barrierDismissible: false,
    );
  }
}
