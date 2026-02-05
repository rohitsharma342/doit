import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/proposal_submission_screen.dart';
import '../screens/proposal_detail_screen.dart';
import '../screens/notifications_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String proposalSubmission = '/proposal-submission';
  static const String proposalDetail = '/proposal-detail';
  static const String notifications = '/notifications';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: proposalSubmission,
        builder: (context, state) => const ProposalSubmissionScreen(),
      ),
      GoRoute(
        path: '$proposalDetail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProposalDetailScreen(proposalId: id);
        },
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
