import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/proposal_submission_screen.dart';
import '../screens/proposal_detail_screen.dart';
import '../screens/notifications_screen.dart';
import '../models/proposal_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String proposalSubmission = '/proposal-submission';
  static const String proposalDetail = '/proposal-detail';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case proposalSubmission:
        return MaterialPageRoute(builder: (_) => const ProposalSubmissionScreen());
      case proposalDetail:
        final proposal = settings.arguments as ProposalModel;
        return MaterialPageRoute(builder: (_) => ProposalDetailScreen(proposal: proposal));
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}