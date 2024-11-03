import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//Adds a new screen to the stack, allowing you to go back
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

//Removes the current screen from the top of the stack
  void goBack() {
    return navigatorKey.currentState!.pop();
  }

//Replaces the current screen with a new one, removing the possibility of returning to it
  Future<void> navigateAndReplace(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  // Clears the navigation stack and navigates to a new screen
  Future<void> navigateAndClearStack(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false, // This removes all previous routes
    );
  }
}

final NavigationService navigationService = NavigationService();
