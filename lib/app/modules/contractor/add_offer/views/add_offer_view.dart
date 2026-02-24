import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/core/utils/validator.dart';
import 'package:app/app/widgets/appbar/appbar.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/add_offer_controller.dart';

class AddOfferView extends GetView<AddOfferController> {
  const AddOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: ListView(
              padding: EdgeInsets.all(30.w),
              children: [
                AppTextField(
                  controller: controller.offerPriceController,
                  textInputType: TextInputType.number,
                  validator: Validator.priceValidator,
                  label: AppStrings.offerPrice.tr,
                  hint: AppStrings.offerPrice.tr,
                ),
                10.verticalSpace,

                AppTextField(
                  controller: controller.offerDurationController,
                  textInputType: TextInputType.number,
                  validator: Validator.numberValidator,
                  label: AppStrings.durationMonths.tr,
                  hint: AppStrings.durationMonths.tr,
                ),
                10.verticalSpace,

                AppTextField(
                  controller: controller.offerDescriptionController,
                  textInputType: TextInputType.multiline,
                  maxLines: 4,
                  validator: Validator.fieldValidator,
                  label: AppStrings.offerDescription.tr,
                  hint: AppStrings.offerDescription.tr,
                ),

                20.verticalSpace,
                Obx(
                  () => AppButton(
                    loading: controller.loading(),
                    text: AppStrings.add.tr,
                    onTap: controller.submitOffer,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
