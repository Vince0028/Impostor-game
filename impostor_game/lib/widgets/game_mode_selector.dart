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
          const SectionHeader(emoji: '🎮', title: 'MISSION TYPE'),
          const SizedBox(height: 16),

          // Mode Toggle
          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  title: 'FIELD OP',
                  icon: Icons.people,
                  isSelected: isClassicMode,
                  onTap: () => setState(() => isClassicMode = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeButton(
                  title: 'REMOTE',
                  icon: Icons.public,
                  isSelected: !isClassicMode,
                  onTap: () {
                    // Online mode not implemented
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Remote uplink offline. Stick to field ops.',
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
                    text: 'FIELD OP: ',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryNeon,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'Physical gathering. Secure device transfer required between agents.',
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
                    text: 'REMOTE COMMS: ',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const TextSpan(
                    text:
                        'Encrypted channel via external networks (Coming Soon).',
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
          color: isSelected ? AppTheme.primaryNeon : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppTheme.primaryNeon : AppTheme.divider,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryNeon.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.black : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : AppTheme.textSecondary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
