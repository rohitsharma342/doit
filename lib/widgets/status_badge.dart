import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/proposal_model.dart';

class StatusBadge extends StatelessWidget {
  final ProposalStatus status;
  final bool isLarge;

  const StatusBadge({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  Color _getStatusColor() {
    switch (status) {
      case ProposalStatus.pending:
        return AppColors.statusPending;
      case ProposalStatus.reviewing:
        return AppColors.statusReviewing;
      case ProposalStatus.approved:
        return AppColors.statusApproved;
      case ProposalStatus.rejected:
        return AppColors.statusRejected;
    }
  }

  String _getStatusText() {
    switch (status) {
      case ProposalStatus.pending:
        return 'Pending';
      case ProposalStatus.reviewing:
        return 'Under Review';
      case ProposalStatus.approved:
        return 'Approved';
      case ProposalStatus.rejected:
        return 'Rejected';
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case ProposalStatus.pending:
        return Icons.schedule;
      case ProposalStatus.reviewing:
        return Icons.rate_review;
      case ProposalStatus.approved:
        return Icons.check_circle;
      case ProposalStatus.rejected:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 10,
        vertical: isLarge ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isLarge ? 12 : 8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: isLarge ? 18 : 14,
            color: color,
          ),
          SizedBox(width: isLarge ? 8 : 4),
          Text(
            _getStatusText(),
            style: TextStyle(
              color: color,
              fontSize: isLarge ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}