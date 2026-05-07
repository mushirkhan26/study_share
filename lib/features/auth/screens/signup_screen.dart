import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/api/network/auth_service.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/utils/validation_utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _collegeController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  UserRole _selectedRole = UserRole.buyer;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final response = await _authService.signup(
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        college: _collegeController.text.trim(),
        role: _selectedRole,
      );

      setState(() => _isLoading = false);

      if (response.success) {
        if (mounted) {
          UIUtils.showSnackBar(context, "Account Created Successfully!");
          context.go(AppRoutes.homeRoute);
        }
      } else {
        if (mounted) {
          UIUtils.showSnackBar(context, response.message ?? "Signup failed", isError: true);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _collegeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      //     onPressed: () => context.pop(),
      //   ),
      //   title: const Text("Create Account"),
      //   backgroundColor: Colors.white,
      //   elevation: 0, // Modern flat look
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //       },
      //       icon: const Icon(Icons.info_outline, size: 22),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text("Create Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Text("Join the Study Share community",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),

                const SizedBox(height: 35),

                // --- Full Name ---
                _buildFieldLabel("Full Name"),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Enter your name", Icons.person_outline),
                  validator: (v) => v!.isEmpty ? "Name is required" : null,
                ),

                const SizedBox(height: 20),

                // --- Email ---
                _buildFieldLabel("Email Address"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Enter your email", Icons.email_outlined),
                  validator: ValidationUtils.validateEmail,
                ),

                const SizedBox(height: 20),

                // --- College Name (Special for BCA/Jodhpur Context) ---
                _buildFieldLabel("College/University"),
                TextFormField(
                  controller: _collegeController,
                  decoration: _inputDecoration("Enter college name", Icons.school_outlined),
                ),

                const SizedBox(height: 20),

                // --- Role Selection ---
                _buildFieldLabel("I want to"),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        title: "Buy Books",
                        icon: Icons.shopping_bag_outlined,
                        role: UserRole.buyer,
                        isSelected: _selectedRole == UserRole.buyer,
                        onTap: () => setState(() => _selectedRole = UserRole.buyer),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildRoleCard(
                        title: "Sell Books",
                        icon: Icons.sell_outlined,
                        role: UserRole.seller,
                        isSelected: _selectedRole == UserRole.seller,
                        onTap: () => setState(() => _selectedRole = UserRole.seller),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // --- Password ---
                _buildFieldLabel("Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: _inputDecoration("Create password", Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: ValidationUtils.validatePassword,
                ),

                const SizedBox(height: 40),

                // --- Register Button ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 25),

                // --- Login Link ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => context.pop(), // Wapas Login par
                      child: const Text("Login", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
      filled: true,
      fillColor: Colors.grey[100],
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}