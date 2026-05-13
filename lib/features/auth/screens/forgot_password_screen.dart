import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  
  bool _otpSent = false;

  Future<void> _handleRequestOTP(AppLocalizations l10n) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final error = await authProvider.forgotPassword(_emailController.text.trim());

      if (error == null) {
        setState(() => _otpSent = true);
        if (mounted) UIUtils.showSnackBar(context, l10n.otpSent);
      } else {
        if (mounted) UIUtils.showSnackBar(context, error, isError: true);
      }
    }
  }

  Future<void> _handleResetPassword(AppLocalizations l10n) async {
    if (_otpController.text.length != 6) {
      UIUtils.showSnackBar(context, l10n.enter6DigitOTP, isError: true);
      return;
    }
    if (_newPasswordController.text.length < 6) {
      UIUtils.showSnackBar(context, l10n.passwordTooShort, isError: true);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProvider.resetPassword(
      _emailController.text.trim(),
      _otpController.text.trim(),
      _newPasswordController.text,
    );

    if (error == null) {
      if (mounted) {
        UIUtils.showSnackBar(context, l10n.passwordResetSuccess);
        context.pop();
      }
    } else {
      if (mounted) UIUtils.showSnackBar(context, error, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.brightness == Brightness.dark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Icon(_otpSent ? Icons.mark_email_read_rounded : Icons.lock_reset_rounded, 
                    size: 80, color: AppColors.primary),
                ),
                const SizedBox(height: 30),
                Text(_otpSent ? l10n.verifyOTP : l10n.forgotPassword,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
                const SizedBox(height: 10),
                Text(
                    _otpSent 
                      ? l10n.enter6DigitCode(_emailController.text)
                      : l10n.enterEmailToReset,
                    style: TextStyle(fontSize: 16, color: theme.hintColor)),

                const SizedBox(height: 40),

                if (!_otpSent) ...[
                  Text(l10n.emailAddress, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: _inputDecoration(l10n.enterEmail, Icons.email_outlined, theme),
                    validator: ValidationUtils.validateEmail,
                  ),
                ] else ...[
                  Text(l10n.enterOTP, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: _inputDecoration(l10n.otpHint, Icons.security, theme),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.newPassword, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: _inputDecoration(l10n.newPasswordHint, Icons.lock_outline, theme),
                  ),
                ],

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading 
                      ? null 
                      : (_otpSent ? () => _handleResetPassword(l10n) : () => _handleRequestOTP(l10n)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_otpSent ? l10n.resetPassword : l10n.sendOTP, 
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                if (_otpSent) 
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _otpSent = false),
                      child: Text(l10n.changeEmail, style: TextStyle(color: theme.hintColor)),
                    ),
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
