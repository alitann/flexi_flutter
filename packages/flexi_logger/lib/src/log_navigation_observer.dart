import 'package:flexi_logger/src/logger.dart';
import 'package:flutter/material.dart';

class LogNavigationObserver extends NavigatorObserver {
  bool _shouldLogRoute(Route<dynamic> route) {
    // Sadece sayfa route'larını logla (PopupRoute, ModalRoute, vs. hariç)
    return route is PageRoute && route.settings.name != null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_shouldLogRoute(route)) {
      final pageName = route.settings.name!;
      Logger().logPageView(pageName);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && _shouldLogRoute(newRoute)) {
      final pageName = newRoute.settings.name!;
      Logger().logPageView(pageName);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null && _shouldLogRoute(previousRoute)) {
      final pageName = route.settings.name!;
      Logger().logPageClosed(pageName);
    }
  }
}
