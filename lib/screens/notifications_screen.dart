import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../providers/notification_provider.dart';
import '../providers/proposal_provider.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>();
    final proposals = context.read<ProposalProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications'),
        actions: [
          if (notifications.unreadCount > 0)
            TextButton(
              onPressed: () => notifications.markAllAsRead(),
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notifications.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You'll see updates here",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications.notifications[index];
                return NotificationItem(
                  notification: notification,
                  onTap: () {
                    notifications.markAsRead(notification.id);
                    if (notification.proposalId != null) {
                      final proposal =
                          proposals.getProposalById(notification.proposalId!);
                      if (proposal != null) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.proposalDetail,
                          arguments: proposal,
                        );
                      }
                    }
                  },
                );
              },
            ),
    );
  }
}