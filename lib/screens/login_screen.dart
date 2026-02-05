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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = context.read<AuthController>();
      final success = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        context.go(AppRoutes.dashboard);
      }
    }
  }

  void _handleQuickLogin(bool isOfficial) {
    final authController = context.read<AuthController>();
    if (isOfficial) {
      authController.loginAsOfficial();
    } else {
      authController.loginAsStartup();
    }
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms).scale(),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Sign in to continue to ${AppConstants.appName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                const SizedBox(height: 48),
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
                  label: AppStrings.email,
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 20),
                CustomTextField(
                  label: AppStrings.password,
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  validator: Validators.validatePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      AppStrings.forgotPassword,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
                const SizedBox(height: 24),
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return CustomButton(
                      text: AppStrings.login,
                      onPressed: _handleLogin,
                      isLoading: authController.isLoading,
                    );
                  },
                ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Quick Access',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Startup',
                        onPressed: () => _handleQuickLogin(false),
                        type: ButtonType.outline,
                        icon: Icons.business_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Official',
                        onPressed: () => _handleQuickLogin(true),
                        type: ButtonType.outline,
                        icon: Icons.admin_panel_settings_outlined,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 900.ms, duration: 500.ms),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: Text(
                        AppStrings.signUp,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1000.ms, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
