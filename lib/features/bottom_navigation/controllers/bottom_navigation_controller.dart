import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void changeTab(int index) {
    if (_currentIndex.value != index) {
      _currentIndex.value = index;
    }
  }

  void setTabByRoute(String route) {
    if (route.startsWith('/home')) {
      _currentIndex.value = 0;
    } else if (route.startsWith('/hubs')) {
      _currentIndex.value = 1;
    } else if (route.startsWith('/bookings')) {
      _currentIndex.value = 2;
    } else if (route.startsWith('/results')) {
      _currentIndex.value = 3;
    } else if (route.startsWith('/profile')) {
      _currentIndex.value = 4;
    }
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('BottomNavigationController initialized');
  }
}

