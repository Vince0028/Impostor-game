import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class RevealScreen extends StatelessWidget {
  const RevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final imposters = provider.gameState.imposters;
        final word = provider.gameState.currentWord ?? '';

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, provider),

                const Spacer(),

                // Imposters Section
                Text(
                  'IMPOSTERS:',
                  style: AppTheme.labelLarge.copyWith(letterSpacing: 1),
                ),
                const SizedBox(height: 8),

                ...imposters.map(
                  (imposter) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      imposter.name,
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Divider(color: AppTheme.divider, thickness: 1),
                ),

                const SizedBox(height: 32),

                // Word Section
                Text(
                  'WORD:',
                  style: AppTheme.labelLarge.copyWith(letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                Text(
                  word,
                  style: AppTheme.titleLarge.copyWith(
                    fontSize: 32,
                    color: AppTheme.imposterRed,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // New Game Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _newGame(context, provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: AppTheme.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: AppTheme.primaryGreen.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      child: const Text(
                        'NEW GAME',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),

          // Title
          Column(
            children: [
              Text(
                'IMPOSTER',
                style: AppTheme.titleLarge.copyWith(
                  fontSize: 24,
                  letterSpacing: 3,
                  color: AppTheme.imposterRed,
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
            onPressed: () => _exitToHome(context, provider),
            icon: const Icon(Icons.close, size: 28),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  void _newGame(BuildContext context, GameProvider provider) {
    provider.startGame();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _exitToHome(BuildContext context, GameProvider provider) {
    provider.resetGame();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }
}
