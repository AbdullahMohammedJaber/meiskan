import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/modules/owner/owner_dashboard/controllers/counter_controller.dart';
import 'package:app/app/widgets/cards/statistic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class OwnerDataAnlayze extends GetView<CountersController> {
  @override
  Widget build(BuildContext context) {
     
     return Obx(() {
       

      

        return Row(
          children: [
            Expanded(
              child: StatisticCard(
                value: controller.allowProject.toString(),
                label: "المشاريع المتاحة",
                iconAsset: AppIcons.house,
                iconBackground: const Color(0xffD8E7E4),
              ),
            ),
            15.horizontalSpace,
            Expanded(
              child: StatisticCard(
                value: controller.totalProject.toString(),
                label: "كافة المشاريع",
                iconAsset: AppIcons.house,
                iconBackground: const Color(0xffD4D3D4),
              ),
            ),
          ],
        );
      });
  }


}