import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'routes.dart';

class DOITApp extends StatelessWidget {
  const DOITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DOIT Rajasthan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
