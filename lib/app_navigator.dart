import 'package:flutter/material.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  Future<void> push<T extends Object?>(Widget page) {
    return navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (_) => page));
  }

  Future<void> pushReplacement<T extends Object?, To extends Object?>(
      Widget page, To? result) {
    return navigatorKey.currentState!.pushReplacement<T, To>(
        MaterialPageRoute(builder: (_) => page),
        result: result);
  }

  Future<void> pushAndRemoveUntil<T extends Object?>(
      Widget page, RoutePredicate predicate) {
    return navigatorKey.currentState!.pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page), predicate);
  }
}
