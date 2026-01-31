import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import 'reveal_screen.dart';
import 'home_screen.dart';

class GameStartedScreen extends StatefulWidget {
  const GameStartedScreen({super.key});

  @override
  State<GameStartedScreen> createState() => _GameStartedScreenState();
}

class _GameStartedScreenState extends State<GameStartedScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  late final Player _startingPlayer;

  @override
  void initState() {
    super.initState();
    final provider = context.read<GameProvider>();
    // Select the starting player once when screen loads
    _startingPlayer = provider.getStartingPlayer();

    if (provider.settings.timeLimitEnabled) {
      _remainingSeconds = provider.settings.timeLimitSeconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        if (mounted) {
          _showTimeExpiredDialog();
        }
      }
    });
  }

  void _showTimeExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(
              Icons.timer_off_outlined,
              color: AppTheme.alertColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'TIME EXPIRED',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.alertColor,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Interrogation window is closed.\n\nProceed to voting immediately.',
          style: AppTheme.bodyLarge,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showReveal(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alertColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('EXPOSE INCOGNITO'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        final startingPlayer = _startingPlayer;

        return Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, provider),

                const Spacer(),

                // Timer Display (if enabled)
                if (provider.settings.timeLimitEnabled) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _remainingSeconds <= 10
                          ? AppTheme.alertColor.withOpacity(0.2)
                          : AppTheme.backgroundSurface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _remainingSeconds <= 10
                            ? AppTheme.alertColor
                            : AppTheme.primaryNeon.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: _remainingSeconds <= 10
                              ? AppTheme.alertColor
                              : AppTheme.primaryNeon,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: AppTheme.titleLarge.copyWith(
                            fontFamily: 'Courier', // Monospaced if available
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _remainingSeconds <= 10
                                ? AppTheme.alertColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

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

  String _formatTime(int totalSeconds) {
    if (totalSeconds <= 0) return "00:00";
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
