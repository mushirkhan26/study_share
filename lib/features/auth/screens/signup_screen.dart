import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/providers/auth_provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _collegeController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<UserRole> _selectedRole = ValueNotifier<UserRole>(UserRole.buyer);
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  Future<void> _handleSignup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.signup(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        college: _collegeController.text.trim(),
        role: _selectedRole.value,
      );

      if (success) {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          UIUtils.showSnackBar(context, l10n.accountCreated);
          context.go(AppRoutes.homeRoute);
        }
      } else {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          UIUtils.showSnackBar(context, l10n.signupFailed, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(l10n.createAccount,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
                Text(l10n.joinCommunity,
                    style: TextStyle(fontSize: 16, color: theme.hintColor)),

                const SizedBox(height: 35),

                // --- Full Name ---
                _buildFieldLabel(l10n.fullName),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: _inputDecoration(l10n.enterName, Icons.person_outline, theme),
                  validator: (v) => v!.isEmpty ? l10n.nameRequired : null,
                ),

                const SizedBox(height: 20),

                // --- Email ---
                _buildFieldLabel(l10n.emailAddress),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: _inputDecoration(l10n.enterEmail, Icons.email_outlined, theme),
                  validator: ValidationUtils.validateEmail,
                ),

                const SizedBox(height: 20),

                // --- College Name (Special for BCA/Jodhpur Context) ---
                _buildFieldLabel(l10n.college),
                TextFormField(
                  controller: _collegeController,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: _inputDecoration(l10n.enterCollege, Icons.school_outlined, theme),
                ),

                const SizedBox(height: 20),

                // --- Role Selection ---
                _buildFieldLabel(l10n.iWantTo),
                ValueListenableBuilder<UserRole>(
                  valueListenable: _selectedRole,
                  builder: (context, role, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildRoleCard(
                            title: l10n.buyBooks,
                            icon: Icons.shopping_bag_outlined,
                            role: UserRole.buyer,
                            isSelected: role == UserRole.buyer,
                            onTap: () => _selectedRole.value = UserRole.buyer,
                            theme: theme,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildRoleCard(
                            title: l10n.sellBooks,
                            icon: Icons.sell_outlined,
                            role: UserRole.seller,
                            isSelected: role == UserRole.seller,
                            onTap: () => _selectedRole.value = UserRole.seller,
                            theme: theme,
                          ),
                        ),
                      ],
                    );
                  }
                ),

                const SizedBox(height: 20),

                // --- Password ---
                _buildFieldLabel(l10n.password),
                ValueListenableBuilder<bool>(
                  valueListenable: _isPasswordVisible,
                  builder: (context, visible, child) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: !visible,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: _inputDecoration(l10n.createPassword, Icons.lock_outline, theme).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => _isPasswordVisible.value = !visible,
                        ),
                      ),
                      validator: ValidationUtils.validatePassword,
                    );
                  }
                ),

                const SizedBox(height: 40),

                // --- Register Button ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : () => _handleSignup(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: authProvider.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(l10n.signUp, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 25),

                // --- Login Link ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.alreadyHaveAccount, style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    TextButton(
                      onPressed: () => context.pop(), // Wapas Login par
                      child: Text(l10n.login, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon, ThemeData theme) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.hintColor),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
      filled: true,
      fillColor: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required UserRole role,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : (theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : theme.dividerColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : theme.hintColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : theme.hintColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
