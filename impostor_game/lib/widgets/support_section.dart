import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heart Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('❤️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              'WANT TO SUPPORT US?',
              style: AppTheme.labelLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Share Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _shareApp(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD54F),
              foregroundColor: AppTheme.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.share, size: 20),
            label: const Text(
              'SHARE WITH FRIENDS',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  void _shareApp() {
    Share.share(
      '🎭 Play Imposter Who? with your friends!\n\nThe ultimate party game where one person is the imposter. Can you find them?\n\nDownload now and join the fun!',
      subject: 'Imposter Who? - Party Game',
    );
  }
}
