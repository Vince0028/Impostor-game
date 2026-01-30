import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/game_mode_selector.dart';
import '../widgets/players_section.dart';
import '../widgets/categories_section.dart';
import '../widgets/imposters_section.dart';
import '../widgets/time_limit_section.dart';
import '../widgets/imposter_hint_section.dart';
import '../widgets/troll_mode_section.dart';
import '../widgets/support_section.dart';
import '../dialogs/how_to_play_dialog.dart';
import 'settings_screen.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Game Mode
                    const GameModeSelector(),
                    const SizedBox(height: 16),

                    // Players
                    const PlayersSection(),
                    const SizedBox(height: 16),

                    // Categories
                    const CategoriesSection(),
                    const SizedBox(height: 16),

                    // Imposters
                    const ImpostersSection(),
                    const SizedBox(height: 16),

                    // Time Limit
                    const TimeLimitSection(),
                    const SizedBox(height: 16),

                    // Imposter Hint
                    const ImposterHintSection(),
                    const SizedBox(height: 16),

                    // Troll Mode
                    const TrollModeSection(),
                    const SizedBox(height: 16),

                    // Support Section
                    const SupportSection(),

                    const SizedBox(height: 120), // Space for button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildStartButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Help Button
          IconButton(
            onPressed: () => _showHowToPlay(context),
            icon: const Icon(Icons.help_outline, size: 28),
            color: AppTheme.textSecondary,
          ),

          // Title
          Column(
            children: [
              Text(
                'IMPOSTER',
                style: AppTheme.titleLarge.copyWith(
                  fontSize: 28,
                  letterSpacing: 3,
                ),
              ),
              Text(
                'WHO?',
                style: AppTheme.titleLarge.copyWith(
                  fontSize: 42,
                  letterSpacing: 5,
                  height: 0.9,
                ),
              ),
            ],
          ),

          // Settings Button
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings, size: 28),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Crown Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text('👑', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),

          // Start Game Button
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () => _startGame(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: AppTheme.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'START GAME',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(context: context, builder: (context) => const HowToPlayDialog());
  }

  void _startGame(BuildContext context) {
    final provider = context.read<GameProvider>();

    // Validate minimum players
    if (provider.players.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need at least 3 players to start!'),
          backgroundColor: AppTheme.imposterRed,
        ),
      );
      return;
    }

    // Validate categories
    if (provider.selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category!'),
          backgroundColor: AppTheme.imposterRed,
        ),
      );
      return;
    }

    // Start the game
    provider.startGame();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }
}
