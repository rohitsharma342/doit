import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/proposal_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
        ChangeNotifierProvider(create: (_) => ProposalController()),
      ],
      child: const DOITApp(),
    ),
  );
}
