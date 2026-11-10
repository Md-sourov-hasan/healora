import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healora/app.dart';
import 'package:healora/core/controllers/healora_state.dart';
import 'package:healora/core/utils/connectivity_service.dart';

export 'package:healora/app.dart' show HealoraApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services & State
  Get.put(ConnectivityService(), permanent: true);
  Get.put(HealoraState(), permanent: true);

  runApp(const HealoraApp());
}
