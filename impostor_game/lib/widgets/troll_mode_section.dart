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
                  const Text('⚠️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'SYSTEM GLITCH',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.alertColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: provider.settings.trollModeEnabled,
                    onChanged: (value) {
                      if (value) {
                        _showWarningDialog(context, provider);
                      } else {
                        provider.toggleTrollMode();
                      }
                    },
                    activeColor: AppTheme.alertColor,
                    activeTrackColor: AppTheme.alertColor.withOpacity(0.3),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'WARNING: System instability may cause all agents to go rogue.',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWarningDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppTheme.alertColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'SYSTEM WARNING',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.alertColor,
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
              'Enabling GLITCH MODE introduces system instability.',
              style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'There is a 20% probability that critical failure occurs, designating ALL AGENTS as Imposters.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Proceed with caution.',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textHint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ABORT'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.toggleTrollMode();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alertColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('INITIALIZE'),
          ),
        ],
      ),
    );
  }
}
