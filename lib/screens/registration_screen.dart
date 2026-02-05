import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/routes.dart';
import '../config/theme.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startupNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _startupNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = context.read<AuthController>();
      final success = await authController.register(
        startupName: _startupNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration successful! Welcome to DOIT.'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.go(AppRoutes.dashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineLarge,
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 8),
                Text(
                  'Register your startup with ${AppConstants.appName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
                const SizedBox(height: 40),
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    if (authController.errorMessage != null) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.errorColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppTheme.errorColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                authController.errorMessage!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.errorColor,
                                    ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () => authController.clearError(),
                              color: AppTheme.errorColor,
                            ),
                          ],
                        ),
                      ).animate().fadeIn().shake();
                    }
                    return const SizedBox.shrink();
                  },
                ),
                CustomTextField(
                  label: AppStrings.startupName,
                  hint: 'Enter your startup name',
                  controller: _startupNameController,
                  prefixIcon: Icons.business_outlined,
                  validator: (value) => Validators.validateRequired(value, 'Startup name'),
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 20),
                CustomTextField(
                  label: AppStrings.email,
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 20),
                CustomTextField(
                  label: AppStrings.password,
                  hint: 'Create a password',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  validator: Validators.validatePassword,
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 20),
                CustomTextField(
                  label: AppStrings.confirmPassword,
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleRegister(),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 32),
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return CustomButton(
                      text: AppStrings.register,
                      onPressed: _handleRegister,
                      isLoading: authController.isLoading,
                    );
                  },
                ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        AppStrings.signIn,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
