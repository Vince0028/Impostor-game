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
                    onChanged: (value) {
                      if (value) {
                        _showInfoDialog(context, provider);
                      } else {
                        provider.toggleTimeLimit();
                      }
                    },
                    activeColor: AppTheme.primaryNeon,
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
                  activeColor: AppTheme.primaryNeon,
                  inactiveColor: AppTheme.primaryNeon.withOpacity(0.2),
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

  void _showInfoDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: AppTheme.primaryNeon,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'MISSION TIMER',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryNeon,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enforce a strict deadline.',
              style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'When the countdown reaches zero, all interrogation must cease immediately and voting begins.',
              style: AppTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.toggleTimeLimit();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryNeon,
              foregroundColor: Colors.black,
            ),
            child: const Text('ACTIVATE'),
          ),
        ],
      ),
    );
  }
}
