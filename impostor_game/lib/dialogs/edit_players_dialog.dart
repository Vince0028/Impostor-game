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
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.2,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      'EDIT PLAYERS',
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('3-20 players', style: AppTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Text('Tap a name to edit', style: AppTheme.bodySmall),
                  ],
                ),
              ),

              // Player List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
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
                        color: AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20, color: AppTheme.textHint),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _editControllers[player.id],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: AppTheme.bodyLarge,
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
                                color: AppTheme.imposterRed,
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

              // Add Player
              if (provider.players.length < 20)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.divider),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newPlayerController,
                            decoration: InputDecoration(
                              hintText: 'Add player name',
                              hintStyle: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textHint,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _addPlayer(provider),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _addPlayer(provider),
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD54F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppTheme.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Confirm Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'CONFIRM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
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
      provider.addPlayer('Player ${provider.players.length + 1}');
    } else {
      provider.addPlayer(name);
    }
    _newPlayerController.clear();
  }
}
