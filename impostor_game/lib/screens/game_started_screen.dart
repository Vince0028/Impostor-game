import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'reveal_screen.dart';
import 'home_screen.dart';

class GameStartedScreen extends StatelessWidget {
  const GameStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final startingPlayer = provider.getStartingPlayer();

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, provider),

                const Spacer(),

                // Game Started Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        'Game started! Time to talk and catch the imposter.',
                        style: AppTheme.titleMedium.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTheme.bodyLarge,
                          children: [
                            WidgetSpan(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  startingPlayer.name,
                                  style: AppTheme.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' starts the conversation!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Recording Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF616161),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.videocam_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'RECORD YOUR MOMENTS',
                          style: AppTheme.labelLarge.copyWith(
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Record your funniest moments and share the madness — who knows, you might go viral.',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Use your phone\'s screen recorder!',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B6B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'START RECORDING',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Reveal Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showReveal(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        side: const BorderSide(
                          color: AppTheme.divider,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'REVEAL IMPOSTER & WORD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // New Game Link
                TextButton(
                  onPressed: () => _startNewGame(context, provider),
                  child: Text(
                    'New Game',
                    style: AppTheme.bodyLarge.copyWith(
                      decoration: TextDecoration.underline,
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
            onPressed: () => _showExitConfirmation(context, provider),
            icon: const Icon(Icons.close, size: 28),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  void _showReveal(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RevealScreen()),
    );
  }

  void _startNewGame(BuildContext context, GameProvider provider) {
    provider.newGame();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _showExitConfirmation(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Game?'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.resetGame();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
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
