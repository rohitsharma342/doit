import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../config/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/proposal_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ProposalSubmissionScreen extends StatefulWidget {
  const ProposalSubmissionScreen({super.key});

  @override
  State<ProposalSubmissionScreen> createState() =>
      _ProposalSubmissionScreenState();
}

class _ProposalSubmissionScreenState extends State<ProposalSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  final List<String> _attachedFiles = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a proposal title';
    }
    if (value.length < 10) {
      return 'Title must be at least 10 characters';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a proposal description';
    }
    if (value.length < 50) {
      return 'Description must be at least 50 characters';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter contact information';
    }
    return null;
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.size > 10 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${file.name} exceeds 10MB limit'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
            continue;
          }
          if (!_attachedFiles.contains(file.name)) {
            setState(() {
              _attachedFiles.add(file.name);
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick files'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeFile(String fileName) {
    setState(() {
      _attachedFiles.remove(fileName);
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final auth = context.read<AuthProvider>();
      final proposals = context.read<ProposalProvider>();
      final notifications = context.read<NotificationProvider>();

      final success = await proposals.submitProposal(
        startupId: auth.currentUser?.id ?? '',
        startupName: auth.currentUser?.name ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        contactInfo: _contactController.text.trim(),
        attachments: _attachedFiles,
      );

      setState(() => _isSubmitting = false);

      if (success && mounted) {
        notifications.addNotification(
          title: 'Submission Received',
          description:
              'Your proposal "${_titleController.text.trim()}" has been successfully submitted.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposal submitted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit proposal. Please try again.'),
            backgroundColor: AppColors.error,
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
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Proposal'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            child: const Text('Submit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Startup Name',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            auth.currentUser?.name ?? 'Unknown',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Proposal Title',
                hint: 'Enter a descriptive title for your proposal',
                controller: _titleController,
                validator: _validateTitle,
                maxLength: 100,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Description',
                hint:
                    'Describe your AI/ML project, its objectives, and expected outcomes...',
                controller: _descriptionController,
                validator: _validateDescription,
                maxLines: 6,
                maxLength: 2000,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Contact Information',
                hint: 'Email, phone number, or other contact details',
                controller: _contactController,
                validator: _validateContact,
                maxLength: 200,
              ),
              const SizedBox(height: 24),
              Text(
                'Attachments',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickFiles,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.divider,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: AppColors.primary.withOpacity(0.6),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to upload files',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PDF, DOC, PPT, XLS (Max 10MB each)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_attachedFiles.isNotEmpty) ...[
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _attachedFiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final fileName = _attachedFiles[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getFileIcon(fileName),
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              fileName,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => _removeFile(fileName),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Submit Proposal',
                      onPressed: _handleSubmit,
                      isLoading: _isSubmitting,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
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
      default:
        return Icons.insert_drive_file;
    }
  }
}