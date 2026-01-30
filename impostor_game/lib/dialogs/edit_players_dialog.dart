import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

class EditPlayersDialog extends StatefulWidget {
  const EditPlayersDialog({super.key});

  @override
  State<EditPlayersDialog> createState() => _EditPlayersDialogState();
}

class _EditPlayersDialogState extends State<EditPlayersDialog> {
  final TextEditingController _newPlayerController = TextEditingController();
  final Map<String, TextEditingController> _editControllers = {};

  @override
  void dispose() {
    _newPlayerController.dispose();
    for (var controller in _editControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: AppTheme.backgroundCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'AGENT ROSTER',
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: AppTheme.primaryNeon,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '3-20 agents required',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap code name to edit',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              // Player List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: provider.players.length,
                  itemBuilder: (context, index) {
                    final player = provider.players[index];
                    _editControllers.putIfAbsent(
                      player.id,
                      () => TextEditingController(text: player.name),
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryNeon.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 20,
                            color: AppTheme.primaryNeon.withOpacity(0.7),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _editControllers[player.id],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: AppTheme.bodyLarge.copyWith(
                                color: Colors.white,
                              ),
                              onChanged: (value) {
                                provider.updatePlayerName(player.id, value);
                              },
                            ),
                          ),
                          if (provider.players.length > 3)
                            IconButton(
                              onPressed: () => provider.removePlayer(player.id),
                              icon: const Icon(
                                Icons.close,
                                color: AppTheme.alertColor,
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section (Add Player + Confirm)
              // Ensure this stays visible above keyboard
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add Player
                    if (provider.players.length < 20)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.textSecondary.withOpacity(0.5),
                            style: BorderStyle.solid,
                          ),
                          color: AppTheme.backgroundSurface.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _newPlayerController,
                                decoration: InputDecoration(
                                  hintText: 'New Agent Code Name',
                                  hintStyle: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textHint,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.white),
                                onSubmitted: (_) => _addPlayer(provider),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _addPlayer(provider),
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryNeon,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
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
                          'CONFIRM ROSTER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addPlayer(GameProvider provider) {
    final name = _newPlayerController.text.trim();
    if (name.isEmpty) {
      provider.addPlayer('Agent ${provider.players.length + 1}');
    } else {
      provider.addPlayer(name);
    }
    _newPlayerController.clear();
  }
}
