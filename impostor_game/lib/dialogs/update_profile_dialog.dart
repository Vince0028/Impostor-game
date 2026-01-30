import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/top_notification.dart';
import '../../services/supabase_service.dart';

class UpdateProfileDialog extends StatefulWidget {
  const UpdateProfileDialog({super.key});

  @override
  State<UpdateProfileDialog> createState() => _UpdateProfileDialogState();
}

class _UpdateProfileDialogState extends State<UpdateProfileDialog> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final newUsername = _usernameController.text.trim();
    final newPassword = _passwordController.text.trim();

    if (newUsername.isEmpty && newPassword.isEmpty) {
      showTopNotification(context, 'No changes detected', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await SupabaseService().updateUser(
        username: newUsername.isNotEmpty ? newUsername : null,
        password: newPassword.isNotEmpty ? newPassword : null,
      );

      if (!mounted) return;

      Navigator.pop(context);
      showTopNotification(context, 'Credentials updated successfully');
    } catch (e) {
      if (!mounted) return;
      showTopNotification(
        context,
        'Update Failed: ${e.toString().replaceAll("Exception: ", "")}',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              hintText:
                  SupabaseService().client.auth.currentUser?.email ??
                  'Agent Email',
              prefixIcon: Icons.email_outlined,
              enabled: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _usernameController,
              hintText: 'New Codename',
              prefixIcon: Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hintText: 'New Passcode',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                  onPressed: _isLoading ? null : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryNeon,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('UPDATE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
