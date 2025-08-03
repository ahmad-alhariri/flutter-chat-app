import 'package:flutter/cupertino.dart';

// ==================================================
// PURPOSE: A dedicated service to manage all app navigation.
// WORKFLOW: This service holds a GlobalKey for the Navigator, allowing ViewModels
// to trigger navigation without needing a BuildContext, which promotes better
// separation of concerns.
// ==================================================
class NavigationService {
  /// A GlobalKey that holds the state of our Navigator.
  /// This is the key to navigating without context.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigates to a named route.
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  /// Navigates to a named route and removes all previous routes.
  Future<dynamic> navigateToAndRemoveUntil(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  /// Goes back to the previous route.
  void goBack() {
    navigatorKey.currentState!.pop();
  }
}
