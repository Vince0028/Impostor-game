import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

class TrollModeSection extends StatelessWidget {
  const TrollModeSection({super.key});

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
                  const Text('😈', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'TROLL MODE',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: provider.settings.trollModeEnabled,
                    onChanged: (_) => provider.toggleTrollMode(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'At some rounds, everyone becomes imposter — it\'s chaos, confusion, and fun.',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
