import 'package:canddy_app/features/game/domain/entities/game_board.dart';

class GameState {
  final GameBoard board;
  final int score;
  final int movesLeft;
  final bool isGameOver;

  const GameState({
    required this.board,
    required this.score,
    required this.movesLeft,
    required this.isGameOver,
  });

  GameState copyWith({
    GameBoard? board,
    int? score,
    int? movesLeft,
    bool? isGameOver,
  }) {
    return GameState(
      board: board ?? this.board,
      score: score ?? this.score,
      movesLeft: movesLeft ?? this.movesLeft,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          board == other.board &&
          score == other.score &&
          movesLeft == other.movesLeft &&
          isGameOver == other.isGameOver;

  @override
  int get hashCode =>
      board.hashCode ^ score.hashCode ^ movesLeft.hashCode ^ isGameOver.hashCode;

  @override
  String toString() =>
      'GameState(score: $score, movesLeft: $movesLeft, isGameOver: $isGameOver)';
}
