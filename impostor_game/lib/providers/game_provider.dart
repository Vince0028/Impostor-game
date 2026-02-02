import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../data/categories_data.dart';

class GameProvider extends ChangeNotifier {
  late GameState _gameState;
  final Random _random = Random();

  GameProvider() {
    _initializeGame();
  }

  GameState get gameState => _gameState;
  List<Player> get players => _gameState.players;
  List<GameCategory> get selectedCategories => _gameState.selectedCategories;
  GameSettings get settings => _gameState.settings;
  List<GameCategory> get allCategories => CategoriesData.allCategories;

  void _initializeGame() {
    _gameState = GameState(
      players: [
        Player(id: '1', name: 'Agent 1'),
        Player(id: '2', name: 'Agent 2'),
        Player(id: '3', name: 'Agent 3'),
      ],
      selectedCategories: [
        CategoriesData.allCategories[0], // Everyday Objects
        CategoriesData.allCategories[1], // Famous People
        CategoriesData.allCategories[2], // Foods & Drinks
      ],
      settings: GameSettings(),
    );
  }

  // Player Management
  void addPlayer(String name) {
    if (_gameState.players.length >= 20) return;

    final newPlayer = Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.isEmpty ? 'Agent ${_gameState.players.length + 1}' : name,
    );

    final updatedPlayers = [..._gameState.players, newPlayer];
    _gameState = _gameState.copyWith(players: updatedPlayers);
    _updateMaxImposters();
    notifyListeners();
  }

  void removePlayer(String playerId) {
    if (_gameState.players.length <= 3) return;

    final updatedPlayers = _gameState.players
        .where((p) => p.id != playerId)
        .toList();
    _gameState = _gameState.copyWith(players: updatedPlayers);
    _updateMaxImposters();
    notifyListeners();
  }

  void updatePlayerName(String playerId, String newName) {
    final updatedPlayers = _gameState.players.map((p) {
      if (p.id == playerId) {
        return p.copyWith(name: newName);
      }
      return p;
    }).toList();

    _gameState = _gameState.copyWith(players: updatedPlayers);
    notifyListeners();
  }

  void reorderPlayers(List<Player> newOrder) {
    _gameState = _gameState.copyWith(players: newOrder);
    notifyListeners();
  }

  // Category Management
  void toggleCategory(GameCategory category) {
    final currentCategories = [..._gameState.selectedCategories];

    if (currentCategories.any((c) => c.id == category.id)) {
      // Don't allow removing if only one category selected
      if (currentCategories.length <= 1) return;
      currentCategories.removeWhere((c) => c.id == category.id);
    } else {
      currentCategories.add(category);
    }

    _gameState = _gameState.copyWith(selectedCategories: currentCategories);
    notifyListeners();
  }

  bool isCategorySelected(GameCategory category) {
    return _gameState.selectedCategories.any((c) => c.id == category.id);
  }

  void selectAllCategories() {
    _gameState = _gameState.copyWith(selectedCategories: [...allCategories]);
    notifyListeners();
  }

  void selectRandomCategories(int count) {
    if (allCategories.isEmpty) return;

    // Create a copy of all categories to shuffle
    final available = [...allCategories];
    available.shuffle(_random);

    // Select the requested number of categories
    final selected = available
        .take(count.clamp(1, allCategories.length))
        .toList();

    _gameState = _gameState.copyWith(selectedCategories: selected);
    _gameState = _gameState.copyWith(selectedCategories: selected);
    notifyListeners();
  }

  void deselectAllCategories() {
    _gameState = _gameState.copyWith(selectedCategories: []);
    notifyListeners();
  }

  // Settings Management
  void updateImposterCount(int count) {
    final maxImposters = _getMaxImposters();
    final newCount = count.clamp(1, maxImposters);

    final updatedSettings = _gameState.settings.copyWith(
      imposterCount: newCount,
    );
    _gameState = _gameState.copyWith(settings: updatedSettings);
    notifyListeners();
  }

  void toggleTimeLimit() {
    final updatedSettings = _gameState.settings.copyWith(
      timeLimitEnabled: !_gameState.settings.timeLimitEnabled,
    );
    _gameState = _gameState.copyWith(settings: updatedSettings);
    notifyListeners();
  }

  void updateTimeLimit(int seconds) {
    final updatedSettings = _gameState.settings.copyWith(
      timeLimitSeconds: seconds,
    );
    _gameState = _gameState.copyWith(settings: updatedSettings);
    notifyListeners();
  }

  void toggleImposterHint() {
    final updatedSettings = _gameState.settings.copyWith(
      imposterHintEnabled: !_gameState.settings.imposterHintEnabled,
    );
    _gameState = _gameState.copyWith(settings: updatedSettings);
    notifyListeners();
  }

  void toggleTrollMode() {
    final isTrollMode = (settings.trollModeEnabled as dynamic) ?? false;
    final isPeaceMode = (settings.allInnocentEnabled as dynamic) ?? false;

    final updatedSettings = _gameState.settings.copyWith(
      trollModeEnabled: !isTrollMode,
      // Disable all innocent mode if enabling troll mode
      allInnocentEnabled: !isTrollMode ? false : isPeaceMode,
    );
    _gameState = _gameState.copyWith(settings: updatedSettings);
    notifyListeners();
  }

  void toggleAllInnocent() {
    final isTrollMode = (settings.trollModeEnabled as dynamic) ?? false;
    final isPeaceMode = (settings.allInnocentEnabled as dynamic) ?? false;

    final updatedSettings = _gameState.settings.copyWith(
      allInnocentEnabled: !isPeaceMode,
      // Disable troll mode if enabling all innocent mode
      trollModeEnabled: !isPeaceMode ? false : isTrollMode,
    );
    _gameState = _gameState.copyWith(settings: updatedSettings);
    notifyListeners();
  }

  int _getMaxImposters() {
    final playerCount = _gameState.players.length;
    if (playerCount <= 5) return 1;
    if (playerCount <= 8) return 2;
    if (playerCount <= 12) return 3;
    return 4;
  }

  void _updateMaxImposters() {
    final maxImposters = _getMaxImposters();
    if (_gameState.settings.imposterCount > maxImposters) {
      updateImposterCount(maxImposters);
    }
  }

  int get maxImposters => _getMaxImposters();

  // Game Flow
  void startGame() {
    // Reset all players
    final resetPlayers = _gameState.players
        .map((p) => p.copyWith(isImposter: false, hasSeenCard: false))
        .toList();

    // Do not shuffle players, keep them in order for pass-and-play
    // resetPlayers.shuffle(_random);

    // Select random imposters
    final imposterIndices = <int>[];
    if (!_gameState.settings.allInnocentEnabled) {
      while (imposterIndices.length < _gameState.settings.imposterCount) {
        final randomIndex = _random.nextInt(resetPlayers.length);
        if (!imposterIndices.contains(randomIndex)) {
          imposterIndices.add(randomIndex);
        }
      }
    }

    // Mark imposters
    for (final index in imposterIndices) {
      resetPlayers[index] = resetPlayers[index].copyWith(isImposter: true);
    }

    // Select random word from selected categories
    final allWords = _gameState.selectedCategories
        .expand<TargetWord>((c) => c.words)
        .toList();
    final selectedWord = allWords[_random.nextInt(allWords.length)];

    // Generate hint if enabled
    String? hint;
    if (_gameState.settings.imposterHintEnabled) {
      hint = selectedWord.hint;
    } else {
      hint = null; // Ensure hint is null if disabled
    }

    // Handle troll mode - sometimes make everyone an imposter
    if (_gameState.settings.trollModeEnabled && _random.nextDouble() < 0.2) {
      // 20% chance everyone is imposter in troll mode
      for (int i = 0; i < resetPlayers.length; i++) {
        resetPlayers[i] = resetPlayers[i].copyWith(isImposter: true);
      }
    }

    _gameState = GameState(
      players: resetPlayers,
      selectedCategories: _gameState.selectedCategories,
      settings: _gameState.settings,
      currentWord: selectedWord.text,
      currentHint: hint,
      currentPlayerIndex: 0,
      gameStarted: false,
      allPlayersReady: false,
    );

    notifyListeners();
  }

  void playerSawCard() {
    final updatedPlayers = [..._gameState.players];
    if (_gameState.currentPlayerIndex < updatedPlayers.length) {
      updatedPlayers[_gameState.currentPlayerIndex] =
          updatedPlayers[_gameState.currentPlayerIndex].copyWith(
            hasSeenCard: true,
          );
    }

    _gameState = _gameState.copyWith(players: updatedPlayers);
    notifyListeners();
  }

  void nextPlayer() {
    final nextIndex = _gameState.currentPlayerIndex + 1;

    if (nextIndex >= _gameState.players.length) {
      // All players have seen their cards
      _gameState = _gameState.copyWith(
        currentPlayerIndex: nextIndex,
        allPlayersReady: true,
        gameStarted: true,
      );
    } else {
      _gameState = _gameState.copyWith(currentPlayerIndex: nextIndex);
    }

    notifyListeners();
  }

  Player? get currentPlayer {
    if (_gameState.currentPlayerIndex >= _gameState.players.length) {
      return null;
    }
    return _gameState.players[_gameState.currentPlayerIndex];
  }

  bool get isLastPlayer =>
      _gameState.currentPlayerIndex >= _gameState.players.length - 1;

  // Get a random player to start the conversation (non-imposter preferred)
  Player getStartingPlayer() {
    final nonImposters = _gameState.players
        .where((p) => !p.isImposter)
        .toList();
    if (nonImposters.isNotEmpty) {
      return nonImposters[_random.nextInt(nonImposters.length)];
    }
    return _gameState.players[_random.nextInt(_gameState.players.length)];
  }

  void resetGame() {
    _gameState = GameState(
      players: _gameState.players,
      selectedCategories: _gameState.selectedCategories,
      settings: _gameState.settings,
      currentWord: null,
      currentHint: null,
      currentPlayerIndex: 0,
      gameStarted: false,
      allPlayersReady: false,
    );
    notifyListeners();
  }

  void newGame() {
    startGame();
  }
}
