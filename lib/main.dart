import 'package:flutter/material.dart';
import 'package:healora/app.dart';

export 'package:healora/app.dart' show HealoraApp;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HealoraApp());
}
