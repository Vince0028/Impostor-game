import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/player_card.dart';
import 'game_started_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final currentPlayer = provider.currentPlayer;

        if (currentPlayer == null || provider.gameState.allPlayersReady) {
          // All players have seen their cards, go to game started screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const GameStartedScreen()),
              );
            }
          });
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Player Card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: PlayerCard(
                      player: currentPlayer,
                      word: provider.gameState.currentWord ?? '',
                      hint: provider.gameState.currentHint,
                      cardColor: AppTheme.getPlayerColor(
                        provider.gameState.currentPlayerIndex,
                      ),
                      onCardRevealed: () {
                        provider.playerSawCard();
                      },
                    ),
                  ),
                ),

                // Next Button
                _buildNextButton(context, provider),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // Balance for close button
          // Title
          Column(
            children: [
              Text(
                'PROJECT',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'INCOGNITO',
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.primaryNeon,
                  fontSize: 28,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),

          // Close Button
          IconButton(
            onPressed: () => _showExitConfirmation(context),
            icon: const Icon(Icons.close, size: 28),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, GameProvider provider) {
    final currentPlayer = provider.currentPlayer;
    if (currentPlayer == null) return const SizedBox.shrink();

    final hasSeenCard = currentPlayer.hasSeenCard;
    final isLastPlayer = provider.isLastPlayer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: hasSeenCard
              ? () {
                  provider.nextPlayer();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryNeon,
            foregroundColor: Colors.black,
            disabledBackgroundColor: AppTheme.backgroundSurface,
            disabledForegroundColor: AppTheme.textHint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: hasSeenCard ? 4 : 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLastPlayer
                    ? Icons.play_arrow_rounded
                    : Icons.skip_next_rounded,
              ),
              const SizedBox(width: 8),
              Text(
                isLastPlayer ? 'INITIATE GAME' : 'NEXT AGENT',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abort Mission?'),
        content: const Text(
          'Are you sure you want to abort? All classified data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('RESUME'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
              context.read<GameProvider>().resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alertColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('ABORT'),
          ),
        ],
      ),
    );
  }
}
