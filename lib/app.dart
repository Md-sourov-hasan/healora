import 'package:flutter/material.dart';
import 'package:healora/core/theme/healora_theme.dart';
import 'package:healora/core/utils/sizer.dart';
import 'package:healora/routes/app_routes.dart';

class HealoraApp extends StatelessWidget {
  const HealoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Healora · Patient Care & Hub Platform',
      debugShowCheckedModeBanner: false,
      theme: HealoraTheme.lightTheme,
      routerConfig: AppRoute.router,
      builder: (context, child) {
        Sizer.init(context);
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
