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
          backgroundColor: AppTheme.backgroundLight,
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
                'IMPOSTER',
                style: AppTheme.titleLarge.copyWith(
                  fontSize: 24,
                  letterSpacing: 3,
                ),
              ),
              Text(
                'WHO?',
                style: AppTheme.titleLarge.copyWith(
                  fontSize: 32,
                  letterSpacing: 5,
                  height: 0.9,
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
            backgroundColor: AppTheme.textPrimary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppTheme.divider,
            disabledForegroundColor: AppTheme.textHint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.skip_next),
              const SizedBox(width: 8),
              Text(
                isLastPlayer ? 'START GAME' : 'NEXT PLAYER',
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
        title: const Text('Exit Game?'),
        content: const Text(
          'Are you sure you want to exit? The current game will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
              context.read<GameProvider>().resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.imposterRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('EXIT'),
          ),
        ],
      ),
    );
  }
}
