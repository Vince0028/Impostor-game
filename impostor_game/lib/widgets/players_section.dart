import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';
import '../dialogs/edit_players_dialog.dart';

class PlayersSection extends StatelessWidget {
  const PlayersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return SectionCard(
          onTap: () => _showEditPlayers(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                emoji: '✋',
                title: 'PLAYERS',
                showChevron: true,
              ),
              const SizedBox(height: 12),

              // Player Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: provider.players.map((player) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      player.name,
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditPlayers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditPlayersDialog(),
    );
  }
}
