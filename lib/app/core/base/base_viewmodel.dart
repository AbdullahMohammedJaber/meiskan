 // ignore_for_file: override_on_non_overriding_member

 import 'package:get/get.dart';

import '../../config/routes/app_pages.dart';
import '../../data/locale/locale_provider.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../utils/app_snackbar.dart';

abstract class BaseController extends GetxController {
  bool _show = false;

  handleError(Failure failure, Function()? onRetry) {
    switch (failure.code) {
      case ResponseCode.UNAUTORISED:
        return _handleUnauthorised();
      default:
        final isArabic = Get.locale?.languageCode == 'ar';
        appSnackbar(
          (isArabic ? failure.message : failure.messageEn) ?? failure.message,
          type: SnackbarType.ERROR,
        );
    }
  }

  _handleUnauthorised() async {
    Get.find<AppPreferences>().dispose();

    Get.offAllNamed(Routes.LOGIN);
  }

  void showLoading() {
    _show = true;

    // StateRendererType.loadingFullScreen.render(context);
  }

  dismiss() {
    if (_show) {
      //context.pop();
    }
  }
}

class NoParams {
  const NoParams();

  @override
  List<Object?> get props => [];

  factory NoParams.fromJson(Map data) {
    return const NoParams();
  }

  Map toJson() => {};
}
