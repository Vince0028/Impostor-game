import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

class ImposterHintSection extends StatelessWidget {
  const ImposterHintSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'IMPOSTER HINT',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: provider.settings.imposterHintEnabled,
                    onChanged: (_) => provider.toggleImposterHint(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Give imposters a hint about the word to help them blend in better.',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
