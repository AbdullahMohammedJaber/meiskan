import 'package:app/app/core/extensions/enums_ex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/constants.dart';
import '../../data/locale/locale_provider.dart';
import '../../data/locale/preferences_keys.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String ACCEPT_LANGUAGE = "Accept-language";

class DioFactory {
  late AppPreferences appPreferences;

  DioFactory() {
    appPreferences = Get.find<AppPreferences>();
  }

  Dio getDio()   {
    Dio dio = Dio();

    String token = appPreferences.token;

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      ACCEPT_LANGUAGE: appPreferences.defaultLanguage.getLocal.toLanguageTag(),
      AUTHORIZATION: "Bearer $token",
    };
    final Interceptor tokenInterceptor = InterceptorsWrapper(
      onRequest: (RequestOptions requestOptions,
          RequestInterceptorHandler handler) async {
        final token0 = appPreferences.read(PreferencesKeys.token);
        final language =
        (appPreferences.defaultLanguage).getLocal.toLanguageTag();

        if(token0!=null) requestOptions.headers.update(AUTHORIZATION, (_) => 'Bearer $token0');
        requestOptions.headers.update(ACCEPT_LANGUAGE, (_) => language);



        handler.next(requestOptions);
      },
    );

    dio.interceptors.add(tokenInterceptor);

    dio.options = BaseOptions(
      baseUrl: Constants.apiBaseUrl,
      headers: headers,
      receiveTimeout: const Duration(seconds: Constants.apiTimeOut),
      sendTimeout: const Duration(seconds: Constants.apiTimeOut),
    );

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }
}
