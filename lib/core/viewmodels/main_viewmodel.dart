import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/enums/enums.dart';
import 'package:flutter_chat_app/core/other/BaseViewModel.dart';

// ==================================================
// PURPOSE: Manages the state for the MainScreen, specifically the bottom navigation.
// ==================================================
class MainViewModel extends BaseViewModel {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final PageController pageController = PageController();

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onTabTapped(int index) {
    _currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }
}