import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'section_card.dart';

class GameModeSelector extends StatefulWidget {
  const GameModeSelector({super.key});

  @override
  State<GameModeSelector> createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends State<GameModeSelector> {
  bool isClassicMode = true;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(emoji: '🎮', title: 'GAME MODE'),
          const SizedBox(height: 16),

          // Mode Toggle
          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  title: 'Classic',
                  icon: Icons.people,
                  isSelected: isClassicMode,
                  onTap: () => setState(() => isClassicMode = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeButton(
                  title: 'Online',
                  icon: Icons.public,
                  isSelected: !isClassicMode,
                  onTap: () {
                    // Online mode not implemented
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Online mode coming soon! Use Classic mode.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Mode Description
          if (isClassicMode) ...[
            RichText(
              text: TextSpan(
                style: AppTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Classic: ',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'Gather in the same room and pass the device between players.',
                  ),
                ],
              ),
            ),
          ] else ...[
            RichText(
              text: TextSpan(
                style: AppTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: 'Online: ',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: 'Play in your group chat (WhatsApp, iMessage, etc.)',
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppTheme.textPrimary : AppTheme.divider,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
