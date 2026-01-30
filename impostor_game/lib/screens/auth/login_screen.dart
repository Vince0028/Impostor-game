import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppTheme.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AGENT LOGS',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.primaryNeon,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Identity\nVerification',
                style: AppTheme.titleLarge.copyWith(fontSize: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Please enter your credentials to access the classified network.',
                style: AppTheme.bodyMedium,
              ),

              const SizedBox(height: 48),

              const CustomTextField(
                hintText: 'Agent ID (Email)',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Passcode',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: Text(
                    'Lost Clearance?',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryNeon,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement actual login logic with Supabase
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryNeon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: AppTheme.primaryNeon.withOpacity(0.5),
                    elevation: 8,
                  ),
                  child: const Text(
                    'ACCESS TERMINAL',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundSurface,
        title: Text(
          'RESET CLEARANCE',
          style: AppTheme.titleMedium.copyWith(color: AppTheme.primaryNeon),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your secure channel ID to receive reset protocols.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              hintText: 'Agent ID (Email)',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Call SupabaseService.instance.sendPasswordResetEmail
              // For now, simulate success
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reset protocols sent to secure channel.'),
                  backgroundColor: AppTheme.primaryNeon,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryNeon,
              foregroundColor: Colors.black,
            ),
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }
}
