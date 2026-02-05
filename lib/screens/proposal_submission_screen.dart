import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/proposal_controller.dart';
import '../services/static_data_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ProposalSubmissionScreen extends StatefulWidget {
  const ProposalSubmissionScreen({super.key});

  @override
  State<ProposalSubmissionScreen> createState() => _ProposalSubmissionScreenState();
}

class _ProposalSubmissionScreenState extends State<ProposalSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().currentUser;
    _contactEmailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: AppConstants.allowedFileTypes,
      );

      if (result != null) {
        final proposalController = context.read<ProposalController>();
        for (final file in result.files) {
          if (file.size <= AppConstants.maxFileSize) {
            proposalController.addFile(file.name);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${file.name} exceeds the maximum file size of 10MB'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error picking files. Please try again.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = context.read<AuthController>();
      final proposalController = context.read<ProposalController>();
      final dashboardController = context.read<DashboardController>();

      final user = authController.currentUser;
      if (user == null) return;

      final newProposal = await proposalController.submitProposal(
        startupId: user.id,
        startupName: user.companyName ?? user.name,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        contactEmail: _contactEmailController.text.trim(),
        contactPhone: _contactPhoneController.text.trim(),
        category: _selectedCategory,
      );

      if (newProposal != null && mounted) {
        dashboardController.addProposal(newProposal);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Proposal submitted successfully!'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Submit Proposal'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showDiscardDialog(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(context),
              const SizedBox(height: 24),
              _buildFormSection(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final user = context.watch<AuthController>().currentUser;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.business,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.companyName ?? user?.name ?? 'Startup',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildFormSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proposal Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: AppStrings.proposalTitle,
              hint: 'Enter a descriptive title for your proposal',
              controller: _titleController,
              maxLength: AppConstants.maxTitleLength,
              validator: (value) => Validators.validateRequired(value, 'Title'),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),
            _buildCategoryDropdown(context).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 20),
            CustomTextField(
              label: AppStrings.proposalDescription,
              hint: 'Describe your proposal in detail...',
              controller: _descriptionController,
              maxLines: 6,
              maxLength: AppConstants.maxDescriptionLength,
              validator: (value) => Validators.validateMinLength(value, 50, 'Description'),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 20),
            CustomTextField(
              label: AppStrings.contactEmail,
              hint: 'contact@yourcompany.com',
              controller: _contactEmailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: Validators.validateEmail,
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 20),
            CustomTextField(
              label: AppStrings.contactPhone,
              hint: '+91 98765 43210',
              controller: _contactPhoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
              validator: Validators.validatePhone,
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 24),
            _buildFileUploadSection(context).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.category,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              hint: const Text('Select a category'),
              items: StaticDataService.getCategories().map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.attachFiles,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              'Max 10MB per file',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _pickFiles,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                ),
                const SizedBox(height: 12),
                Text(
                  'Click to upload files',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PDF, DOC, PNG, JPG, MP4',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Consumer<ProposalController>(
          builder: (context, controller, child) {
            if (controller.uploadedFiles.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              children: controller.uploadedFiles.map((fileName) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getFileIcon(fileName),
                        color: AppTheme.primaryColor,
                        size: 20,
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
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => controller.removeFile(fileName),
                        color: AppTheme.textSecondary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
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
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      case 'mp4':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: AppStrings.cancel,
              onPressed: () => _showDiscardDialog(),
              type: ButtonType.outline,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Consumer<ProposalController>(
              builder: (context, controller, child) {
                return CustomButton(
                  text: AppStrings.submit,
                  onPressed: _handleSubmit,
                  isLoading: controller.isSubmitting,
                  icon: Icons.send,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDiscardDialog() {
    if (_titleController.text.isEmpty &&
        _descriptionController.text.isEmpty &&
        context.read<ProposalController>().uploadedFiles.isEmpty) {
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Discard Changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Editing'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.read<ProposalController>().clearFiles();
              this.context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
