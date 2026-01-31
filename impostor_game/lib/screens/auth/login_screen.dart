import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';
import '../../utils/top_notification.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showTopNotification(
        context,
        'Please enter both Agent ID and Passcode',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService().signIn(email, password);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      showTopNotification(context, e.message, isError: true);
    } catch (e) {
      if (!mounted) return;
      final message =
          e.toString().contains('SocketException') ||
              e.toString().contains('ClientException')
          ? 'Secure Connection Failed: No Internet'
          : 'Access Denied: Unexpected error.';
      showTopNotification(context, message, isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailResetController = TextEditingController();

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
              controller: emailResetController,
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
              final email = emailResetController.text.trim();
              if (email.isEmpty) {
                showTopNotification(
                  context,
                  'Please enter your Agent ID',
                  isError: true,
                );
                return;
              }

              try {
                await SupabaseService().sendPasswordResetEmail(email);
                if (context.mounted) {
                  Navigator.pop(context);
                  showTopNotification(
                    context,
                    'Reset protocols sent to secure channel.',
                  );
                }
              } on AuthException catch (e) {
                if (context.mounted) {
                  showTopNotification(context, e.message, isError: true);
                }
              } catch (e) {
                if (context.mounted) {
                  final message =
                      e.toString().contains('SocketException') ||
                          e.toString().contains('ClientException')
                      ? 'Connection Failed: No Internet'
                      : 'Failed to send reset protocols.';
                  showTopNotification(context, message, isError: true);
                }
              }
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

              CustomTextField(
                controller: _emailController,
                hintText: 'Agent ID (Email)',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
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
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryNeon,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: AppTheme.primaryNeon.withOpacity(0.5),
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
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
}
