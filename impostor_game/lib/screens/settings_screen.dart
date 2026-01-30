import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          'Settings',
          style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // General Settings
            _buildSettingsCard(
              children: [
                _buildSettingItem(
                  title: 'Change Language',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('English is the only language available'),
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildSettingItem(
                  title: 'Share with Friends',
                  onTap: () => _shareApp(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Legal Settings
            _buildSettingsCard(
              children: [
                _buildSettingItem(
                  title: 'Terms of Use',
                  onTap: () => _showTerms(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  title: 'Privacy',
                  onTap: () => _showPrivacy(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Purchases
            _buildSettingsCard(
              children: [
                _buildSettingItem(
                  title: 'Restore Purchases',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Everything is FREE! No purchases to restore 🎉',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Footer
            Text('Email: support@imposterwho.app', style: AppTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('v1.0.0', style: AppTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTheme.bodyLarge),
            const Icon(Icons.chevron_right, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1),
    );
  }

  void _shareApp() {
    Share.share(
      '🎭 Play Imposter Who? with your friends!\n\nThe ultimate party game where one person is the imposter. Can you find them?\n\nAll categories are FREE! No paywalls!',
      subject: 'Imposter Who? - Party Game',
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Use'),
        content: const SingleChildScrollView(
          child: Text(
            'Imposter Who? Terms of Use\n\n'
            '1. This game is provided free of charge for personal entertainment.\n\n'
            '2. All categories and words are included at no cost.\n\n'
            '3. The game is designed for players aged 12 and above.\n\n'
            '4. We do not collect any personal data.\n\n'
            '5. Play responsibly and have fun!\n\n'
            'By using this app, you agree to these terms.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Imposter Who? Privacy Policy\n\n'
            '🔒 We respect your privacy!\n\n'
            '• We do NOT collect any personal information.\n\n'
            '• We do NOT track your gameplay.\n\n'
            '• We do NOT share any data with third parties.\n\n'
            '• All game data stays on your device.\n\n'
            '• No account required to play.\n\n'
            'This app is designed to be simple, fun, and privacy-friendly.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
