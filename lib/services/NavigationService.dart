import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationService {
  // region Singleton
  static final NavigationService instance = NavigationService._internal();

  NavigationService._internal();

  // endregion

  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToReplacement(String _rn) {
    if (navigationKey.currentState == null) {
      debugPrint("currentState not found");
    }
    return navigationKey.currentState!.pushReplacementNamed(_rn);
  }

  Future<dynamic> navigateTo(String _rn) {
    if (navigationKey.currentState == null) {
      debugPrint("currentState not found");
    }
    return navigationKey.currentState!.pushNamed(_rn);
  }

  Future<dynamic> navigateToRoute(Widget page) {
    if (navigationKey.currentState == null) {
      debugPrint("currentState not found");
    }
    return Navigator.push(
      navigationKey.currentState!.context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: const Duration(seconds: 0),
        reverseTransitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  Future<dynamic> navigateToRouteReplacement(Widget page) {
    if (navigationKey.currentState == null) {
      debugPrint("currentState not found");
    }
    return Navigator.pushReplacement(
      navigationKey.currentState!.context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: const Duration(seconds: 0),
        reverseTransitionDuration: const Duration(seconds: 0),
      ),
    );
  }

  goback() {
    if (navigationKey.currentState == null) {
      debugPrint("currentState not found");
    }
    return navigationKey.currentState!.pop();
  }

  Future<Object?> goToScreen({
    required BuildContext context,
    required String screenName,
    required Widget screen,
    Object? args,
    required bool replaceCurrentScreen,
    bool withTransitionAnimation = true,
  }) {
    Route r = PageRouteBuilder(
      settings: RouteSettings(
        name: screenName,
        arguments: args ?? {},
      ),
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: withTransitionAnimation
          ? const Duration(milliseconds: 200)
          : Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation1, animation2, widget) =>
          SlideTransition(
        position: animation1
            .drive(Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)),
        child: widget,
      ),
    );

    if (replaceCurrentScreen) {
      Navigator.of(context).pushReplacement(r);
    } else {
      Navigator.of(context).push(r);
    }
    return r.popped;
  }

  Future<Object?> fadeToScreen({
    required BuildContext context,
    required String screenName,
    required Widget screen,
    Object? args,
    required bool replaceCurrentScreen,
    bool withTransitionAnimation = true,
  }) {
    Route r = PageRouteBuilder(
      settings: RouteSettings(
        name: screenName,
        arguments: args ?? {},
      ),
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: withTransitionAnimation
          ? const Duration(milliseconds: 300)
          : Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation1, animation2, widget) =>
          FadeTransition(opacity: animation1, child: widget),
    );

    if (replaceCurrentScreen) {
      Navigator.of(context).pushReplacement(r);
    } else {
      Navigator.of(context).push(r);
    }
    return r.popped;
  }
}
