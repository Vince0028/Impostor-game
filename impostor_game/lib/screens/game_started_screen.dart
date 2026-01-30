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
          backgroundColor: AppTheme.backgroundDark,
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
                        'MISSION ACTIVE',
                        style: AppTheme.labelLarge.copyWith(
                          fontSize: 18,
                          letterSpacing: 4,
                          color: AppTheme.alertColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Interrogate agents.\nIdentify the spy.',
                        style: AppTheme.titleMedium.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryNeon.withOpacity(0.3),
                          ),
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: startingPlayer.name,
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryNeon,
                                  fontSize: 20,
                                ),
                              ),
                              const TextSpan(
                                text: '\nstarts the interrogation.',
                                style: TextStyle(
                                  height: 1.5,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Recording Section (Simplified or removed? Kept but styled)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SURVEILLANCE',
                                style: AppTheme.labelLarge.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Record the session for evidence.',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Reveal Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _showReveal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.alertColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: AppTheme.alertColor.withOpacity(0.4),
                      ),
                      child: const Text(
                        'EXPOSE INCOGNITO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Abort Mission
                TextButton(
                  onPressed: () => _showExitConfirmation(context, provider),
                  child: Text(
                    'Abort Mission',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
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

  void _showExitConfirmation(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abort Mission?'),
        content: const Text('Are you sure you want to abort?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('RESUME'),
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
