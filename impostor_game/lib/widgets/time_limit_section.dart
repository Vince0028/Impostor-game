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
                  const Text('⏰', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'TIME LIMIT',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: provider.settings.timeLimitEnabled,
                    onChanged: (_) => provider.toggleTimeLimit(),
                  ),
                ],
              ),
              Text(
                provider.settings.timeLimitEnabled
                    ? '${provider.settings.timeLimitSeconds} seconds'
                    : 'Disabled',
                style: AppTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}
