import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

class PeaceModeSection extends StatelessWidget {
  const PeaceModeSection({super.key});

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
                  const Text('✌️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'PEACE PROTOCOL',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.primaryNeon,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value:
                        (provider.settings.allInnocentEnabled as dynamic) ??
                        false,
                    onChanged: (value) {
                      provider.toggleAllInnocent();
                    },
                    activeColor: AppTheme.primaryNeon,
                    activeTrackColor: AppTheme.primaryNeon.withOpacity(0.3),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Training Exercise: No Incognito agents will be infiltrated.',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
