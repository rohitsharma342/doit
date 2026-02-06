import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/proposal_provider.dart';
import 'providers/notification_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DOITApp());
}

class DOITApp extends StatelessWidget {
  const DOITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProposalProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'DOIT Rajasthan',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}