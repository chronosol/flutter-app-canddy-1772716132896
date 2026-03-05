import 'package:canddy/features/game/domain/entities/candy.dart';

class GameBoard {
  final List<List<Candy?>> board;
  final int size;

  GameBoard({required this.board, required this.size});

  GameBoard copyWith({
    List<List<Candy?>>? board,
    int? size,
  }) {
    return GameBoard(
      board: board ?? this.board,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameBoard &&
          runtimeType == other.runtimeType &&
          board == other.board &&
          size == other.size;

  @override
  int get hashCode => board.hashCode ^ size.hashCode;

  @override
  String toString() => 'GameBoard(size: $size, board: $board)';
}
