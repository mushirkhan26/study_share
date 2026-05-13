import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (context.mounted) {
          UIUtils.showSnackBar(context, "Login Successful!");
          context.go(AppRoutes.homeRoute);
        }
      } else {
        if (context.mounted) {
          UIUtils.showSnackBar(context, "Login failed", isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isPasswordVisible = ValueNotifier<bool>(false);

    return Scaffold(
      backgroundColor: Colors.white,
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
                const Text("Welcome Back!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Text("Login to access your study notes",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),

                const SizedBox(height: 40),

                const Text("Email Address", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Enter your email", Icons.email_outlined),
                  validator: (value) => ValidationUtils.validateEmail(value),
                ),

                const SizedBox(height: 20),

                const Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: isPasswordVisible,
                  builder: (context, visible, child) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: !visible,
                      decoration: _inputDecoration("Enter password", Icons.lock_outline).copyWith(
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
                    child: const Text("Forgot Password?", style: TextStyle(color: AppColors.primary)),
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
                      : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signupRoute),
                      child: const Text("Sign Up", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
