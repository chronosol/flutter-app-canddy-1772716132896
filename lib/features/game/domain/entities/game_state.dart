enum GameStatus {
  loading,
  playing,
  swapping,
  matching,
  falling,
  refilling,
  gameOver,
  paused,
}

class GameState {
  final GameStatus status;
  final int score;
  final int movesLeft;
  final int level; // Not implemented, but good to have for future
  final String? message;

  const GameState({
    this.status = GameStatus.loading,
    this.score = 0,
    this.movesLeft = 0,
    this.level = 1,
    this.message,
  });

  GameState copyWith({
    GameStatus? status,
    int? score,
    int? movesLeft,
    int? level,
    String? message,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      movesLeft: movesLeft ?? this.movesLeft,
      level: level ?? this.level,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          score == other.score &&
          movesLeft == other.movesLeft &&
          level == other.level &&
          message == other.message;

  @override
  int get hashCode =>
      status.hashCode ^
      score.hashCode ^
      movesLeft.hashCode ^
      level.hashCode ^
      message.hashCode;

  @override
  String toString() =>
      'GameState(status: $status, score: $score, movesLeft: $movesLeft)';
}
