import 'package:flutter/material.dart';
import 'package:social_app/services/auth/auth_service.dart';


class ForgotPasswordDialog extends StatefulWidget {
  final AuthService authService;

  const ForgotPasswordDialog({super.key, required this.authService});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void sendReset() async {
    setState(() => isLoading = true);

    try {
      await widget.authService.sendPasswordResetEmail(emailController.text.trim());
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Reset Password"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Enter your email to receive password reset instructions."),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
        ],
      ),
      actions: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CircularProgressIndicator(),
          )
        else ...[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: sendReset,
            child: const Text("Send"),
          ),
        ]
      ],
    );
  }
}