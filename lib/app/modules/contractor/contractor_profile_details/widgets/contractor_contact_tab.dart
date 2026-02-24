import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/app_images.dart';
import 'package:app/app/data/model/contractor_detailed_model.dart';
import 'package:app/app/data/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../widgets/social_button.dart';

class ContractorContactTab extends StatelessWidget {
  final ContractorDetailedModel contractor;

  const ContractorContactTab({super.key, required this.contractor});

  bool _hasLink(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  Uri? _normalizeLink(String? value) {
    if (!_hasLink(value)) {
      return null;
    }

    final trimmed = value!.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      return null;
    }

    if (uri.scheme.isEmpty) {
      return Uri.tryParse('https://$trimmed');
    }

    return uri;
  }

  Future<void> _openLink(String? value) async {
    final uri = _normalizeLink(value);
    if (uri == null) {
      return;
    }
    launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    );
  }

  @override
  Widget build(BuildContext context) {
    final socialButtons = <Widget>[
      if (_hasLink(contractor.facebookLink))
        SocialButton(
          iconPath: AppIcons.facebook,
          onTap: () => _openLink(contractor.facebookLink),
        ),
      if (_hasLink(contractor.whatsappLink))
        SocialButton(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 16.w,
          ),
          onTap: () => _openLink(contractor.whatsappLink),
        ),
      if (_hasLink(contractor.snapchatLink))
        SocialButton(
          icon: Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: 16.w,
          ),
          onTap: () => _openLink(contractor.snapchatLink),
        ),
      if (_hasLink(contractor.instagramLink))
        SocialButton(
          iconPath: AppIcons.instagram,
          onTap: () => _openLink(contractor.instagramLink),
        ),
      if (_hasLink(contractor.tiktokLink))
        SocialButton(
          iconPath: AppIcons.tiktok,
          onTap: () => _openLink(contractor.tiktokLink),
        ),
      if (_hasLink(contractor.linkedinLink))
        SocialButton(
          iconPath: AppIcons.linkedin,
          onTap: () => _openLink(contractor.linkedinLink),
        ),
      if (_hasLink(contractor.xLink))
        SocialButton(
          iconPath: AppIcons.x,
          onTap: () => _openLink(contractor.xLink),
        ),
    ];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ContactRow(
                svgIcon: AppIcons.phone,
                text: contractor.phoneNumber,
                onTap: () {},
              ),
              const Divider(),
              _ContactRow(
                svgIcon: AppIcons.emailOutlined,
                text: contractor.email,
                onTap: () {},
              ),
              const Divider(),
              if (contractor.experiancDes.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.describeExperiance.tr,
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      Text(
                        contractor.experiancDes,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                        style: Get.textTheme.bodyMedium!.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              10.verticalSpace,
              if (socialButtons.isNotEmpty)
                Center(
                  child: Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: socialButtons,
                  ),
                ),
            ],
          ),
        ),
        15.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.pointStar,
                width: 100.w,
              ),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.nbOfemainingOffers.tr,
                    style: Get.textTheme.bodyMedium!.copyWith(fontSize: 17.sp),
                  ),
                  5.verticalSpace,
                  Text(
                    '${contractor.ballanceOffers} ${AppStrings.offer.tr}',
                    style: Get.textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
        15.verticalSpace,
        _transactionsSection(),
      ],
    );
  }

  Widget _transactionsSection() {
    final items = List<TransactionModel>.from(contractor.transactions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.lastPurchases.tr,
          style: Get.textTheme.bodyMedium!.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        12.verticalSpace,
        if (items.isEmpty)
          Text(
            AppStrings.noItems.tr,
            style: Get.textTheme.bodySmall!.copyWith(
              color: AppColors.grey,
              fontSize: 12.sp,
            ),
          )
        else
          Column(
            children: List.generate(
              items.length,
              (index) => _TransactionCard(
                transaction: items[index],
                isLast: index == items.length - 1,
              ),
            ),
          ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final bool isLast;

  const _TransactionCard({
    required this.transaction,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _InfoCell(
            label: AppStrings.transactionDate.tr,
            value: _formatDate(transaction.createdAt),
          ),
          _InfoCell(
            label: AppStrings.pointsCount.tr,
            value: '${transaction.offerNum} ${AppStrings.point.tr}',
          ),
          _InfoCell(
            label: AppStrings.totalAmount.tr,
            value: _formatAmount(transaction),
          ),
          _InfoCell(
            label: AppStrings.inOffers.tr,
            value: transaction.inOffer ? AppStrings.yes.tr : AppStrings.no.tr,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date == DateTime(0)) {
      return '-';
    }
    return DateFormat('d/M/yyyy').format(date);
  }

  String _formatAmount(TransactionModel transaction) {
    final amount = transaction.amount.toStringAsFixed(2);
    final currency = transaction.currency.toUpperCase() == 'KWD'
        ? AppStrings.kwd.tr
        : transaction.currency;
    return '$amount $currency';
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCell({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodySmall!.copyWith(
              fontSize: 12.sp,
              color: AppColors.grey,
            ),
          ),
          6.verticalSpace,
          Text(
            value,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium!.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.svgIcon,
    required this.text,
    required this.onTap,
  });

  final String svgIcon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Colors.transparent,
        child: Row(
          children: [
            SvgPicture.asset(
              svgIcon,
              width: 25.w,
              height: 25.w,
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                text,
                style: Get.textTheme.bodyMedium!.copyWith(fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
