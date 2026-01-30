import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class SelectImpostersDialog extends StatelessWidget {
  const SelectImpostersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final playerCount = provider.players.length;
        final maxImposters = provider.maxImposters;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppTheme.backgroundCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Text(
                'AGENTS VS INCOGNITO',
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppTheme.primaryNeon,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'With $playerCount agents, balance the threat level.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Imposter Options
              ...List.generate(maxImposters, (index) {
                final count = index + 1;
                final isSelected = provider.settings.imposterCount == count;

                return InkWell(
                  onTap: () => provider.updateImposterCount(count),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryNeon.withOpacity(0.1)
                          : AppTheme.backgroundSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryNeon
                            : AppTheme.divider.withOpacity(0.5),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryNeon.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$count Incognito${count > 1 ? 's' : ''}',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryNeon,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryNeon,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: AppTheme.primaryNeon.withOpacity(0.4),
                  ),
                  child: const Text(
                    'CONFIRM THREAT LEVEL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
