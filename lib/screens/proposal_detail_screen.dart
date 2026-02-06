import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import '../models/proposal_model.dart';
import '../providers/auth_provider.dart';
import '../providers/proposal_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ProposalDetailScreen extends StatefulWidget {
  final ProposalModel proposal;

  const ProposalDetailScreen({super.key, required this.proposal});

  @override
  State<ProposalDetailScreen> createState() => _ProposalDetailScreenState();
}

class _ProposalDetailScreenState extends State<ProposalDetailScreen> {
  late ProposalModel _proposal;
  final _commentController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _proposal = widget.proposal;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showStatusUpdateDialog() {
    final auth = context.read<AuthProvider>();
    if (!auth.isOfficial) return;

    ProposalStatus? selectedStatus = _proposal.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Update Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select new status:',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ...ProposalStatus.values.map((status) {
                    return RadioListTile<ProposalStatus>(
                      title: Text(_getStatusLabel(status)),
                      value: status,
                      groupValue: selectedStatus,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setDialogState(() => selectedStatus = value);
                      },
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: 'Add a comment (optional)',
                    controller: _commentController,
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedStatus != _proposal.status
                      ? () async {
                          Navigator.pop(context);
                          await _updateStatus(selectedStatus!);
                        }
                      : null,
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getStatusLabel(ProposalStatus status) {
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

  Future<void> _updateStatus(ProposalStatus newStatus) async {
    setState(() => _isUpdating = true);

    final auth = context.read<AuthProvider>();
    final proposals = context.read<ProposalProvider>();
    final notifications = context.read<NotificationProvider>();

    final success = await proposals.updateProposalStatus(
      _proposal.id,
      newStatus,
      comment: _commentController.text.trim().isNotEmpty
          ? _commentController.text.trim()
          : null,
      userId: auth.currentUser?.id,
      userName: auth.currentUser?.name,
    );

    setState(() => _isUpdating = false);

    if (success) {
      final updatedProposal = proposals.getProposalById(_proposal.id);
      if (updatedProposal != null) {
        setState(() => _proposal = updatedProposal);
      }

      notifications.addNotification(
        title: 'Status Updated',
        description:
            'Proposal "${_proposal.title}" status changed to ${_getStatusLabel(newStatus)}',
        proposalId: _proposal.id,
      );

      _commentController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Proposal Details'),
        actions: [
          if (auth.isOfficial)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: _isUpdating ? null : _showStatusUpdateDialog,
            ),
        ],
      ),
      body: _isUpdating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _proposal.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      StatusBadge(status: _proposal.status, isLarge: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            _proposal.startupName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _proposal.startupName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                _proposal.contactInfo,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Description',
                    Icons.description_outlined,
                    child: Text(
                      _proposal.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'Timeline',
                    Icons.schedule_outlined,
                    child: Column(
                      children: [
                        _buildTimelineItem(
                          'Submitted',
                          DateFormat('MMMM dd, yyyy • hh:mm a')
                              .format(_proposal.createdAt),
                          true,
                        ),
                        if (_proposal.createdAt != _proposal.updatedAt)
                          _buildTimelineItem(
                            'Last Updated',
                            DateFormat('MMMM dd, yyyy • hh:mm a')
                                .format(_proposal.updatedAt),
                            false,
                          ),
                      ],
                    ),
                  ),
                  if (_proposal.attachments.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      'Attachments',
                      Icons.attach_file,
                      child: Column(
                        children: _proposal.attachments.map((file) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getFileIcon(file),
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    file,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.download_outlined,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Downloading $file...'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_proposal.comments.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      'Comments',
                      Icons.comment_outlined,
                      child: Column(
                        children: _proposal.comments.map((comment) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          AppColors.primary.withOpacity(0.1),
                                      child: Text(
                                        comment.userName
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.userName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          Text(
                                            DateFormat('MMM dd, yyyy')
                                                .format(comment.createdAt),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.textLight,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  comment.content,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  if (auth.isOfficial) ...[
                    CustomButton(
                      text: 'Update Status',
                      onPressed: _showStatusUpdateDialog,
                      icon: Icons.edit_outlined,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title, IconData icon, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTimelineItem(String label, String value, bool isFirst) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isFirst ? AppColors.primary : AppColors.textLight,
                shape: BoxShape.circle,
              ),
            ),
            if (!isFirst)
              Container(
                width: 2,
                height: 24,
                color: AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }
}