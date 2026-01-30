import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo/Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.backgroundSurface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryNeon.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                  border: Border.all(color: AppTheme.primaryNeon, width: 2),
                ),
                child: const Icon(
                  Icons.fingerprint,
                  size: 64,
                  color: AppTheme.primaryNeon,
                ),
              ),
              const SizedBox(height: 48),

              // Title
              Text(
                'PROJECT',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'INCOGNITO',
                style: AppTheme.titleLarge.copyWith(
                  fontSize: 48,
                  color: AppTheme.textPrimary,
                  shadows: [
                    Shadow(
                      color: AppTheme.primaryNeon.withOpacity(0.8),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Buttons
              _buildAuthButton(
                context,
                title: 'IDENTIFY',
                subtitle: 'Existing Agent Login',
                icon: Icons.login,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                isPrimary: true,
              ),
              const SizedBox(height: 16),
              _buildAuthButton(
                context,
                title: 'ENLIST',
                subtitle: 'New Agent Registration',
                icon: Icons.person_add_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                ),
                isPrimary: false,
              ),

              const Spacer(),
              Text(
                'SECURE CONNECTION REQUIRED',
                style: AppTheme.bodySmall.copyWith(
                  letterSpacing: 2,
                  color: AppTheme.textHint.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: isPrimary ? AppTheme.primaryNeon : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPrimary ? AppTheme.primaryNeon : AppTheme.divider,
              width: 2,
            ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppTheme.primaryNeon.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.black : AppTheme.primaryNeon,
                size: 28,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: isPrimary ? Colors.black : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isPrimary
                          ? Colors.black.withOpacity(0.7)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: isPrimary ? Colors.black : AppTheme.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
