import 'package:app/app/core/utils/app_icons.dart';
import 'package:app/app/core/utils/strings_manager.dart';
 
import '../../../../core/base/base_viewmodel.dart';

class ContractorProfileAction {
  const ContractorProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;
}

class ContractorProfileController extends BaseController {
  final String contractorName = AppStrings.contractorName;

  final actions = const <ContractorProfileAction>[
    ContractorProfileAction(
      icon: AppIcons.userOutlined,
      title: AppStrings.contactInfo,
      subtitle: AppStrings.contractorContactDetails,
    ),
    ContractorProfileAction(
      icon: AppIcons.badge,
      title: AppStrings.workPortfolio,
      subtitle: AppStrings.contractorPortfolioDetails,
    ),
    ContractorProfileAction(
      icon: AppIcons.star,
      title: AppStrings.reviews,
      subtitle: AppStrings.contractorReviewsDetails,
    ),
  ];
}
