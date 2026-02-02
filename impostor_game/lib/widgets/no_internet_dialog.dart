import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const NoInternetDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.alertColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.alertColor.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with glow
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.alertColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppTheme.alertColor,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'CONNECTION LOST',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.alertColor,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'Unable to establish a secure link to the mainframe.\n\nPlease check your internet connection and try again.',
              style: AppTheme.bodyMedium.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.alertColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: AppTheme.alertColor.withOpacity(0.5),
                  elevation: 8,
                ),
                child: const Text(
                  'ACKNOWLEDGE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
