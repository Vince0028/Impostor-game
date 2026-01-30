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
                    'INCOGNITO INTEL',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.primaryNeon,
                      letterSpacing: 1.5,
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
                'Leak restricted data to help incognito agents blend in.',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
