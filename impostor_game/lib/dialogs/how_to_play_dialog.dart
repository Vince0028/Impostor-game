import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppTheme.backgroundSurface,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mission Briefing',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryNeon,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppTheme.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Steps
            _buildStep(
              1,
              'Get 3-5 friends together and pass the device around.',
              AppTheme.cardCyan,
            ),
            const SizedBox(height: 16),
            _buildStep(
              2,
              'Everyone sees the secret word, but one person sees "INCOGNITO".',
              AppTheme.cardPurple,
            ),
            const SizedBox(height: 16),
            _buildStep(
              3,
              'Take turns saying a word related to the secret topic.',
              AppTheme.cardPink,
            ),
            const SizedBox(height: 16),
            _buildStep(
              4,
              'If you are Incognito, blend in! Don\'t get caught.',
              AppTheme.cardOrange,
            ),
            const SizedBox(height: 16),
            _buildStep(
              5,
              'Vote for who you suspect. Uncover the truth!',
              AppTheme.alertColor,
            ),

            const SizedBox(height: 24),

            // Footer
            Text(
              '// TIP: Act confident. Hesitation reveals the spy.',
              style: AppTheme.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String text, Color numberColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: numberColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: numberColor),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: numberColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text, style: AppTheme.bodyLarge.copyWith(height: 1.3)),
        ),
      ],
    );
  }
}
