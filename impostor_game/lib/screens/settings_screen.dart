import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../utils/top_notification.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          'Command Center',
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
                    showTopNotification(
                      context,
                      'English is the only mission language available',
                    );
                  },
                ),
                _buildDivider(),
                _buildSettingItem(
                  title: 'Recruit Agents',
                  onTap: () => _shareApp(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Legal Settings
            _buildSettingsCard(
              children: [
                _buildSettingItem(
                  title: 'Mission Protocols',
                  onTap: () => _showTerms(context),
                ),
                _buildDivider(),
                _buildSettingItem(
                  title: 'Classified Data',
                  onTap: () => _showPrivacy(context),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Footer
            Text('Support: support@incognito.game', style: AppTheme.bodyMedium),
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
        color: AppTheme.backgroundSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
      child: Divider(height: 1, color: AppTheme.divider),
    );
  }

  void _shareApp() {
    Share.share(
      '🕵️ Mission: INCOGNITO\n\nThe ultimate hidden identity game. Can you blend in?\n\nJoin the mission now!',
      subject: 'Incognito - Social Deduction Game',
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mission Protocols'),
        content: const SingleChildScrollView(
          child: Text(
            'INCOGNITO Protocols\n\n'
            '1. This tool is free for all agents.\n\n'
            '2. All operations are classified and local to your device.\n\n'
            '3. Maintain cover at all times.\n\n'
            '4. No data is intercepted or transmitted.\n\n'
            'By initiating, you agree to these terms.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ACKNOWLEDGED'),
          ),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Classified Data'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Clearance Level 5\n\n'
            '• We do NOT collect agent data.\n\n'
            '• We do NOT track mission logs.\n\n'
            '• We do NOT share intel with third parties.\n\n'
            '• All data remains on this device.\n\n'
            'Stay hidden, stay safe.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ACKNOWLEDGED'),
          ),
        ],
      ),
    );
  }
}
