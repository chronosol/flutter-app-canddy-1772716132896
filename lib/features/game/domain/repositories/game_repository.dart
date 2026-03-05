import 'package:canddy/features/game/domain/entities/candy.dart';
import 'package:canddy/features/game/domain/entities/game_board.dart';

abstract class GameRepository {
  GameBoard initializeBoard(int size);
  Future<GameBoard> swapCandies(GameBoard board, Candy candy1, Candy candy2);
  Future<Map<String, dynamic>> processMatches(GameBoard board);
  Future<GameBoard> refillBoard(GameBoard board);
  bool hasPossibleMoves(GameBoard board);
}
