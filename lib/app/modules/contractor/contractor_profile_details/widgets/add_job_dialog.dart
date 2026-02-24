import 'dart:io';

import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/strings_manager.dart';
import 'package:app/app/modules/contractor/contractor_profile_details/controllers/contractor_profile_details_controller.dart';
import 'package:app/app/widgets/default_button.dart';
import 'package:app/app/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddJobDialog extends StatefulWidget {
  const AddJobDialog({super.key});

  @override
  State<AddJobDialog> createState() => _AddJobDialogState();
}

class _AddJobDialogState extends State<AddJobDialog> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onFieldChanged(String _) => setState(() {});

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (pickedFile != null) {
      setState(() => _selectedImage = pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContractorProfileDetailsController>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.projectImages.tr,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                        onPressed: Get.back, icon: const Icon(Icons.close))
                  ],
                ),
                16.verticalSpace,
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 220.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    child: _selectedImage == null
                        ? SvgPicture.asset(
                            AppIcons.gallery,
                            width: 90.w,
                            height: 90.h,
                          )
                        : Image.file(
                            File(_selectedImage!.path),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                20.verticalSpace,
                AppTextField(
                  controller: _companyNameController,
                  label: AppStrings.projectExecutingEntityName.tr,
                  hint: AppStrings.projectExecutingEntityNameHint.tr,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AppStrings.thisFieldIsRequired.tr
                      : null,
                  onChanged: _onFieldChanged,
                ),
                16.verticalSpace,
                AppTextField(
                  controller: _locationController,
                  label: AppStrings.projectLocation.tr,
                  hint: AppStrings.projectLocationHint.tr,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AppStrings.thisFieldIsRequired.tr
                      : null,
                  onChanged: _onFieldChanged,
                ),
                16.verticalSpace,
                AppTextField(
                  controller: _descriptionController,
                  label: AppStrings.projectDescription.tr,
                  hint: AppStrings.projectDescription.tr,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AppStrings.thisFieldIsRequired.tr
                      : null,
                  onChanged: _onFieldChanged,
                ),
                24.verticalSpace,
                Obx(
                  () {
                    final isSubmitting = controller.isAddingJob.value;
                    final hasImage = _selectedImage != null;
                    final hasText =
                        _companyNameController.text.trim().isNotEmpty &&
                            _locationController.text.trim().isNotEmpty &&
                            _descriptionController.text.trim().isNotEmpty;
                    final canSubmit = hasImage && hasText && !isSubmitting;

                    return AppButton(
                      text: AppStrings.add.tr,
                      enabled: canSubmit,
                      loading: isSubmitting,
                      onTap: canSubmit
                          ? () {
                              if (!(_formKey.currentState?.validate() ??
                                  false)) {
                                setState(() {});
                                return;
                              }

                              controller.addJob(
                                image: _selectedImage!,
                                companyName: _companyNameController.text.trim(),
                                location: _locationController.text.trim(),
                                description: _descriptionController.text.trim(),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
