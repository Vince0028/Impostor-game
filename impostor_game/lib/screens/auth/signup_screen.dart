import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/supabase_service.dart';
import '../../utils/top_notification.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showTopNotification(context, 'Please fill in all fields', isError: true);
      return;
    }

    if (password != confirmPassword) {
      showTopNotification(context, 'Passcodes do not match', isError: true);
      return;
    }

    if (password.length < 6) {
      showTopNotification(
        context,
        'Passcode must be at least 6 characters',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService().signUp(email, password, username);

      if (!mounted) return;

      // Show success message and navigate to Login
      // We assume email confirmation is required based on user context
      showTopNotification(
        context,
        'Clearance pending. Check secure channel (email) for activation link.',
        duration: const Duration(seconds: 5),
      );

      // Wait a bit so user sees the message
      await Future.delayed(const Duration(seconds: 5));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      showTopNotification(
        context,
        'Registration Failed: ${e.toString().replaceAll("Exception: ", "")}',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                'NEW RECRUIT',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.secondaryNeon,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Agent\nRegistration',
                style: AppTheme.titleLarge.copyWith(fontSize: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Create a new profile to join the agency and start your first mission.',
                style: AppTheme.bodyMedium,
              ),

              const SizedBox(height: 48),

              CustomTextField(
                controller: _usernameController,
                hintText: 'Codename (Username)',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                hintText: 'Secure Channel (Email)',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Set Passcode',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Passcode',
                prefixIcon: Icons.lock_reset,
                isPassword: true,
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryNeon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: AppTheme.secondaryNeon.withOpacity(0.5),
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'FINALIZE RECRUITMENT',
                          style: TextStyle(
                            color: Colors.white,
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
}
