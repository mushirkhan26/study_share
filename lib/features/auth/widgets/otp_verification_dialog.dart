import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../core/utils/ui_utils.dart';

class OTPVerificationDialog extends StatefulWidget {
  final String email;

  const OTPVerificationDialog({super.key, required this.email});

  @override
  State<OTPVerificationDialog> createState() => _OTPVerificationDialogState();
}

class _OTPVerificationDialogState extends State<OTPVerificationDialog> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Column(
        children: [
          Icon(Icons.security_rounded, size: 50, color: AppColors.primary),
          SizedBox(height: 10),
          Text("Two-Factor Authentication", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("We've sent a 6-digit OTP to\n${widget.email}", 
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
            decoration: InputDecoration(
              hintText: "000000",
              hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.3)),
              counterText: "",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _verify,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: _isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Verify"),
        ),
      ],
    );
  }

  Future<void> _verify() async {
    if (_otpController.text.length != 6) {
      UIUtils.showSnackBar(context, "Please enter 6-digit OTP", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verify2FA(widget.email, _otpController.text);
    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        Navigator.pop(context); // Close dialog
        UIUtils.showSnackBar(context, "Verification Successful!");
        context.go(AppRoutes.homeRoute); // Go to Home
      }
    } else {
      if (mounted) {
        UIUtils.showSnackBar(context, "Invalid or expired OTP", isError: true);
      }
    }
  }
}
