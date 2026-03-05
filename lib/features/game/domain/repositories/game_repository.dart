import 'package:canddy_app/features/game/domain/entities/game_state.dart';

abstract class GameRepository {
  Future<GameState> initializeGame();
  Future<GameState> makeMove(GameState currentState, int index1, int index2);
}
