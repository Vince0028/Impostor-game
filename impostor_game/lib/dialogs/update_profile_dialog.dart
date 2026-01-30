import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/top_notification.dart';

class UpdateProfileDialog extends StatelessWidget {
  const UpdateProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for fields
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Dialog(
      backgroundColor: AppTheme.backgroundSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UPDATE CREDENTIALS',
              style: AppTheme.titleMedium.copyWith(color: AppTheme.primaryNeon),
            ),
            const SizedBox(height: 16),
            Text(
              'Modify your agent identification details.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: usernameController,
              hintText: 'New Codename',
              prefixIcon: Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              hintText: 'New Passcode',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Call Supabase update logic
                    final newUsername = usernameController.text.trim();
                    final newPassword = passwordController.text.trim();

                    if (newUsername.isEmpty && newPassword.isEmpty) {
                      showTopNotification(
                        context,
                        'No changes detected',
                        isError: true,
                      );
                      return;
                    }

                    Navigator.pop(context);
                    showTopNotification(
                      context,
                      'Credentials updated successfully',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryNeon,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('UPDATE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
