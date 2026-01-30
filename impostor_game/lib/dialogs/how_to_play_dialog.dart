import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  'How to Play',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Steps
            _buildStep(
              1,
              'Gather 3-5 friends and pass the phone around.',
              AppTheme.imposterRed,
            ),
            const SizedBox(height: 16),
            _buildStep(
              2,
              'Each player swipes to see the secret word — except one person, who will see "Imposter."',
              AppTheme.imposterRed,
            ),
            const SizedBox(height: 16),
            _buildStep(
              3,
              'One by one, players say a word related to the secret word.',
              AppTheme.imposterRed,
            ),
            const SizedBox(height: 16),
            _buildStep(
              4,
              'The imposter must fake it and try to blend in without knowing the word.',
              AppTheme.imposterRed,
            ),
            const SizedBox(height: 16),
            _buildStep(
              5,
              'Keep giving clues and talking until someone thinks they\'ve figured it out.',
              AppTheme.imposterRed,
            ),
            const SizedBox(height: 16),
            _buildStep(
              6,
              'When you\'re ready, vote for who you think the imposter is — then tap to reveal the truth!',
              AppTheme.imposterRed,
            ),

            const SizedBox(height: 24),

            // Footer
            Text(
              '* Record the chaos! Share your funniest rounds on social media and tag your friends.',
              style: AppTheme.bodySmall.copyWith(fontStyle: FontStyle.italic),
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
        Text(
          '$number',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: numberColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTheme.bodyLarge)),
      ],
    );
  }
}
