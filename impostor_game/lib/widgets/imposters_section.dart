import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';
import '../dialogs/select_imposters_dialog.dart';

class ImpostersSection extends StatelessWidget {
  const ImpostersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return SectionCard(
          onTap: () => _showSelectImposters(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🕵️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'IMPOSTERS',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: AppTheme.textHint),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${provider.settings.imposterCount} Imposter${provider.settings.imposterCount > 1 ? 's' : ''}',
                style: AppTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSelectImposters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SelectImpostersDialog(),
    );
  }
}
