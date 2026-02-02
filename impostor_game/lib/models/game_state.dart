/// Represents a player in the game
class Player {
  final String id;
  String name;
  bool isImposter;
  bool hasSeenCard;

  Player({
    required this.id,
    required this.name,
    this.isImposter = false,
    this.hasSeenCard = false,
  });

  Player copyWith({
    String? id,
    String? name,
    bool? isImposter,
    bool? hasSeenCard,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      isImposter: isImposter ?? this.isImposter,
      hasSeenCard: hasSeenCard ?? this.hasSeenCard,
    );
  }
}

/// Represents a word with a corresponding hint
class TargetWord {
  final String text;
  final String hint;

  const TargetWord(this.text, this.hint);
}

/// Represents a category with its words
class GameCategory {
  final String id;
  final String name;
  final String emoji;
  final List<TargetWord> words;

  const GameCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.words,
  });
}

/// Game settings
class GameSettings {
  int imposterCount;
  bool timeLimitEnabled;
  int timeLimitSeconds;
  bool imposterHintEnabled;
  bool trollModeEnabled;
  bool allInnocentEnabled;

  GameSettings({
    this.imposterCount = 1,
    this.timeLimitEnabled = false,
    this.timeLimitSeconds = 60,
    this.imposterHintEnabled = false,
    this.trollModeEnabled = false,
    this.allInnocentEnabled = false,
  });

  GameSettings copyWith({
    int? imposterCount,
    bool? timeLimitEnabled,
    int? timeLimitSeconds,
    bool? imposterHintEnabled,
    bool? trollModeEnabled,
    bool? allInnocentEnabled,
  }) {
    return GameSettings(
      imposterCount: imposterCount ?? this.imposterCount,
      timeLimitEnabled: timeLimitEnabled ?? this.timeLimitEnabled,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      imposterHintEnabled: imposterHintEnabled ?? this.imposterHintEnabled,
      trollModeEnabled: trollModeEnabled ?? this.trollModeEnabled,
      allInnocentEnabled: allInnocentEnabled ?? this.allInnocentEnabled,
    );
  }
}

/// Current game state
class GameState {
  final List<Player> players;
  final List<GameCategory> selectedCategories;
  final GameSettings settings;
  final String? currentWord;
  final String? currentHint;
  final int currentPlayerIndex;
  final bool gameStarted;
  final bool allPlayersReady;

  GameState({
    required this.players,
    required this.selectedCategories,
    required this.settings,
    this.currentWord,
    this.currentHint,
    this.currentPlayerIndex = 0,
    this.gameStarted = false,
    this.allPlayersReady = false,
  });

  GameState copyWith({
    List<Player>? players,
    List<GameCategory>? selectedCategories,
    GameSettings? settings,
    String? currentWord,
    String? currentHint,
    int? currentPlayerIndex,
    bool? gameStarted,
    bool? allPlayersReady,
  }) {
    return GameState(
      players: players ?? this.players,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      settings: settings ?? this.settings,
      currentWord: currentWord ?? this.currentWord,
      currentHint: currentHint ?? this.currentHint,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      gameStarted: gameStarted ?? this.gameStarted,
      allPlayersReady: allPlayersReady ?? this.allPlayersReady,
    );
  }

  List<Player> get imposters => players.where((p) => p.isImposter).toList();
  Player? get currentPlayer =>
      players.isNotEmpty && currentPlayerIndex < players.length
      ? players[currentPlayerIndex]
      : null;
}
