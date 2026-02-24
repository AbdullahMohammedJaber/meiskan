import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../middlwares/user_middleware.dart';
import '../../modules/chat/bindings/chat_binding.dart';
import '../../modules/chat/views/chat_view.dart';
import '../../modules/contractor/add_offer/bindings/add_offer_binding.dart';
import '../../modules/contractor/add_offer/views/add_offer_view.dart';
import '../../modules/contractor/contractor_dashboard/bindings/contractor_dashboard_binding.dart';
import '../../modules/contractor/contractor_dashboard/views/contractor_dashboard_view.dart';
import '../../modules/contractor/contractor_home/bindings/contractor_home_binding.dart';
import '../../modules/contractor/contractor_home/views/contractor_home_view.dart';
import '../../modules/contractor/contractor_edit_profile/bindings/contractor_edit_profile_binding.dart';
import '../../modules/contractor/contractor_edit_profile/views/contractor_edit_profile_view.dart';
import '../../modules/contractor/contractor_profile/bindings/contractor_profile_binding.dart';
import '../../modules/contractor/contractor_profile/views/contractor_profile_view.dart';
import '../../modules/contractor/contractor_profile_details/bindings/contractor_profile_details_binding.dart';
import '../../modules/contractor/contractor_profile_details/views/contractor_profile_details_view.dart';
import '../../modules/contractor/contractor_ratings/bindings/contractor_ratings_binding.dart';
import '../../modules/contractor/contractor_ratings/views/contractor_ratings_view.dart';
import '../../modules/conversations/bindings/conversations_binding.dart';
 import '../../modules/conversations/views/conversations_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/login/bindings/login_binding.dart';
import '../../modules/login/views/login_view.dart';
import '../../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../../modules/forgot_password/views/forgot_password_view.dart';
import '../../modules/forgot_password/views/forgot_password_otp_view.dart';
import '../../modules/forgot_password/views/reset_password_view.dart';
import '../../modules/notifications/bindings/notifications_binding.dart';
import '../../modules/notifications/views/notifications_view.dart';
import '../../modules/owner/create_project/bindings/create_project_binding.dart';
import '../../modules/owner/create_project/views/create_project_view.dart';
import '../../modules/owner/owner_dashboard/bindings/owner_dashboard_binding.dart';
import '../../modules/owner/owner_dashboard/views/owner_dashboard_view.dart';
import '../../modules/project/bindings/project_binding.dart';
import '../../modules/project/views/project_view.dart';
import '../../modules/register/bindings/register_binding.dart';
import '../../modules/register/views/register_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/status/views/error_screen.dart';
import '../../modules/status/views/success_screen.dart';
import '../../modules/terms_and_conditions/bindings/terms_and_conditions_binding.dart';
import '../../modules/terms_and_conditions/views/terms_and_conditions_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final List<GetPage> routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.USER_MIDDLEWARE,
      page: () => const UserMiddleWare(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PROJECT,
      page: () => const CreateProjectView(),
      binding: CreateProjectBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION_SUCCESS,
      page: () => const SuccessScreen(),
    ),
    GetPage(
      name: _Paths.VERIFICATION_ERROR,
      page: () => const ErrorScreen(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.OWNER_DASHBOARD,
      page: () => const OwnerDashboardView(),
      binding: OwnerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT + '/:id',
      page: () => const ProjectView(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGES,
      page: () => const ConversationsView(),
      binding: ConversationsBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.CONTRACTOR_HOME,
      page: () => const ContractorHomeView(),
      binding: ContractorHomeBinding(),
    ),
    GetPage(
      name: _Paths.CONTRACTOR_DASHBOARD,
      page: () => ContractorDashboardView(),
      binding: ContractorDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CONTRACTOR_PROFILE,
      page: () => const ContractorProfileView(),
      binding: ContractorProfileBinding(),
    ),
    GetPage(
      name: _Paths.CONTRACTOR_PROFILE_DETAILS,
      page: () => const ContractorProfileDetailsView(),
      binding: ContractorProfileDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CONTRACTOR_EDIT_PROFILE,
      page: () => const ContractorEditProfileView(),
      binding: ContractorEditProfileBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => const TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_OFFER,
      page: () => const AddOfferView(),
      binding: AddOfferBinding(),
    ),
    GetPage(
      name: _Paths.CONTRACTOR_RATINGS,
      page: () => const ContractorRatingsView(),
      binding: ContractorRatingsBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD_OTP,
      page: () => const ForgotPasswordOtpView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
  ];
}
