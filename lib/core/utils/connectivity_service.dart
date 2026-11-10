import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('ConnectivityService initialized');
  }

  Future<bool> checkConnection() async {
    return isConnected.value;
  }

  void setConnection(bool value) {
    isConnected.value = value;
  }
}

