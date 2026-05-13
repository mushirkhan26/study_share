import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/providers/auth_provider.dart';
import '../widgets/otp_verification_dialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final result = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        if (result == 'SUCCESS') {
          UIUtils.showSnackBar(context, l10n.loginSuccessful);
          context.go(AppRoutes.homeRoute);
        } else if (result == '2FA_REQUIRED') {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => OTPVerificationDialog(email: _emailController.text.trim()),
          );
        } else {
          UIUtils.showSnackBar(context, result ?? l10n.loginFailed, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final isPasswordVisible = ValueNotifier<bool>(false);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    AppConstants.logo, 
                    height: 100,
                    errorBuilder: (context, e, s) => const Icon(Icons.school_rounded, size: 80, color: AppColors.primary)
                  ),
                ),
                const SizedBox(height: 30),
                Text(l10n.welcomeBack,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
                Text(l10n.loginToAccess,
                    style: TextStyle(fontSize: 16, color: theme.hintColor)),

                const SizedBox(height: 40),

                Text(l10n.emailAddress, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: _inputDecoration(l10n.enterEmail, Icons.email_outlined, theme),
                  validator: (value) => ValidationUtils.validateEmail(value),
                ),

                const SizedBox(height: 20),

                Text(l10n.password, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: isPasswordVisible,
                  builder: (context, visible, child) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: !visible,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: _inputDecoration(l10n.enterPassword, Icons.lock_outline, theme).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => isPasswordVisible.value = !visible,
                        ),
                      ),
                      validator: (value) => ValidationUtils.validatePassword(value),
                    );
                  }
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(l10n.forgotPassword, style: const TextStyle(color: AppColors.primary)),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(l10n.login, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.dontHaveAccount, style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signupRoute),
                      child: Text(l10n.signUp, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon, ThemeData theme) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.hintColor),
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
