/*
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

bool appLinksInitialized = false;

class AppLinksManager {
  static final _appLinks = AppLinks();

  static init() async {
    _appLinks.uriLinkStream.listen(_handleDeepLink);

    if (!appLinksInitialized) {
      final Uri? uri = await _appLinks.getInitialLink();
      _handleDeepLink(uri);
      appLinksInitialized = true;
    }
  }

  static _handleDeepLink(Uri? uri) async {
    if (uri == null) return;
    debugPrint('_handleDeepLink => $uri');
    debugPrint('uri.queryParameters => ${uri.queryParameters}');
    try {
      Get.toNamed(uri.path,parameters: uri.queryParameters);
    } catch (error) {
      debugPrint('error => $error');
    }
  }
}
*/
