import 'package:app/app/core/enums/enums.dart';
import 'package:app/app/gobal_controllers/user_controller.dart';
import 'package:app/app/modules/home/controllers/home_controller.dart';
import 'package:app/app/widgets/cards/plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePlans extends StatelessWidget {
  const HomePlans({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = Get.find<UserController>().user();
      if (user != null && user.type == AccountType.contractor) {
        final controller = Get.find<HomeController>();
        return Padding(
          padding: EdgeInsets.only(
            right: 26.w,
            left: 26.w,
            bottom: 50.h,
            top: 50.h,
          ),
          child: Column(
            children: [
              // Title
              Text(
                'باقات نقاطنا المميزة',
                style: Get.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
              ),
              25.verticalSpace,

              // Plans list
              Obx(() {
                if (controller.isLoadingPlans.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.plans.isEmpty) {
                  return const Text('لا توجد خطط متاحة');
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.plans.length,
                  separatorBuilder: (context, index) => 20.verticalSpace,
                  itemBuilder: (context, index) {
                    final plan = controller.plans[index];
                    // Alternate pattern: black, white, black
                    final isDark = index % 2 == 0;
                    return PlanCard(
                      plan: plan,
                      isDarkTheme: isDark,
                    );
                  },
                );
              }),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}