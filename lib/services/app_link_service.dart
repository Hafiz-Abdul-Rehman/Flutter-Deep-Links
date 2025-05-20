import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../main.dart';

class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance = AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial deep link (cold start)
    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      _handleUri(appLink);
    }

    // Listen to live deep links (warm/resumed)
    _linkSubscription = _appLinks.uriLinkStream.listen(
          (uri) => _handleUri(uri),
      onError: (err) => debugPrint('App link error: $err'),
    );
  }
  void _handleUri(Uri uri) {
    debugPrint('Received deep link: $uri');

    final segments = uri.pathSegments;
    if (segments.isNotEmpty && segments[0] == 'counter' && segments.length > 1) {
      final value = int.tryParse(segments[1]);
      if (value != null) {
        Get.to(() => MySecondHome(counter: value));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => MySecondHome(counter: value),
        //   ),
        // );
      }
    }
  }

}
