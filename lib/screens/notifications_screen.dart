import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/routes.dart';
import '../config/theme.dart';
import '../controllers/notification_controller.dart';
import '../utils/constants.dart';
import '../widgets/notification_item.dart';
import '../widgets/loading_indicator.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationController>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        actions: [
          Consumer<NotificationController>(
            builder: (context, controller, child) {
              if (controller.unreadCount > 0) {
                return TextButton(
                  onPressed: () => controller.markAllAsRead(),
                  child: const Text('Mark all read'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const LoadingIndicator(message: 'Loading notifications...');
          }

          if (controller.notifications.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: AppStrings.noNotifications,
              subtitle: 'You will receive notifications about your proposals here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadNotifications(),
            color: AppTheme.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return NotificationItem(
                  notification: notification,
                  onTap: () {
                    controller.markAsRead(notification.id);
                    if (notification.relatedProposalId != null) {
                      context.push('${AppRoutes.proposalDetail}/${notification.relatedProposalId}');
                    }
                  },
                ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX(begin: 0.1, end: 0);
              },
            ),
          );
        },
      ),
    );
  }
}
