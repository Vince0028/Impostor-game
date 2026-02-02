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
          backgroundColor: AppTheme.backgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, provider),

                const Spacer(),

                // Imposters Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.alertColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.alertColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'INCOGNITO AGENTS',
                        style: AppTheme.labelLarge.copyWith(
                          letterSpacing: 2,
                          color: AppTheme.alertColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...imposters.map(
                        (imposter) => Text(
                          imposter.name.toUpperCase(),
                          style: AppTheme.titleLarge.copyWith(
                            fontSize: 32,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Word Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNeon.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryNeon),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'SECRET PASSCODE',
                        style: AppTheme.labelLarge.copyWith(
                          letterSpacing: 2,
                          color: AppTheme.primaryNeon,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        word.toUpperCase(),
                        style: AppTheme.titleLarge.copyWith(
                          fontSize: 32,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                if (provider.gameState.settings.imposterHintEnabled &&
                    provider.gameState.currentHint != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryNeon.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.secondaryNeon),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'CLASSIFIED INTEL',
                          style: AppTheme.labelLarge.copyWith(
                            letterSpacing: 2,
                            color: AppTheme.secondaryNeon,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.gameState.currentHint!,
                          style: AppTheme.titleMedium.copyWith(
                            fontSize: 24,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],

                const Spacer(),

                // New Game Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _newGame(context, provider),
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
                        'INITIATE NEW MISSION',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
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
                  fontSize: 24,
                  letterSpacing: 2,
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
    // Reset needed state but keep players/categories if desired?
    // For now we assume startGame handles logic or we route to Home
    provider
        .newGame(); // Use newGame instead of startGame to reset and go to setup
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
