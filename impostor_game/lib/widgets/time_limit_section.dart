import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

class TimeLimitSection extends StatelessWidget {
  const TimeLimitSection({super.key});

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
                  const Text('⏱️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'MISSION DEADLINE',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.primaryNeon,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: provider.settings.timeLimitEnabled,
                    onChanged: (_) => provider.toggleTimeLimit(),
                  ),
                ],
              ),
              if (provider.settings.timeLimitEnabled) ...[
                const SizedBox(height: 12),
                Slider(
                  value: provider.settings.timeLimitSeconds.toDouble(),
                  min: 30,
                  max: 180,
                  divisions: 5,
                  label: '${provider.settings.timeLimitSeconds}s',
                  onChanged: (value) => provider.updateTimeLimit(value.toInt()),
                ),
                Text(
                  '${provider.settings.timeLimitSeconds} SECONDS',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryNeon,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
