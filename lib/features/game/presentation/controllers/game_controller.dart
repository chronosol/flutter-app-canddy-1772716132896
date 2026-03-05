import 'dart:async';
import 'dart:math';

import 'package:canddy/core/constants/app_constants.dart';
import 'package:canddy/features/game/data/repositories/game_repository_impl.dart';
import 'package:canddy/features/game/data/repositories/score_repository_impl.dart';
import 'package:canddy/features/game/domain/entities/candy.dart';
import 'package:canddy/features/game/domain/entities/game_board.dart';
import 'package:canddy/features/game/domain/entities/game_state.dart';
import 'package:canddy/features/game/domain/entities/score_entry.dart';
import 'package:canddy/features/game/domain/repositories/game_repository.dart';
import 'package:canddy/features/game/domain/repositories/score_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for repositories
final gameRepositoryProvider = Provider<GameRepository>((ref) => GameRepositoryImpl());
final scoreRepositoryProvider = Provider<ScoreRepository>((ref) => ScoreRepositoryImpl());

// Game Controller
class GameController extends AsyncNotifier<GameBoard> {
  GameState _gameState = const GameState();
  GameState get gameState => _gameState;

  Candy? _selectedCandy;
  Candy? get selectedCandy => _selectedCandy;

  @override
  Future<GameBoard> build() async {
    _gameState = const GameState(
      status: GameStatus.loading,
      score: 0,
      movesLeft: AppConstants.initialMoves,
    );
    final initialBoard = ref.read(gameRepositoryProvider).initializeBoard(AppConstants.boardSize);
    _gameState = _gameState.copyWith(status: GameStatus.playing);
    return initialBoard;
  }

  void startGame() {
    _selectedCandy = null;
    _gameState = const GameState(
      status: GameStatus.loading,
      score: 0,
      movesLeft: AppConstants.initialMoves,
    );
    state = const AsyncValue.loading();
    ref.invalidateSelf(); // Rebuilds the board
  }

  void selectCandy(Candy candy) {
    if (_gameState.status != GameStatus.playing) return;

    if (_selectedCandy == null) {
      _selectedCandy = candy;
    } else if (_selectedCandy == candy) {
      _selectedCandy = null; // Deselect
    } else {
      // Second candy selected, attempt swap
      _attemptSwap(_selectedCandy!, candy);
      _selectedCandy = null; // Clear selection after attempt
    }
  }

  Future<void> _attemptSwap(Candy candy1, Candy candy2) async {
    if (!(_isAdjacent(candy1, candy2))) {
      _gameState = _gameState.copyWith(message: 'Candies must be adjacent!');
      return;
    }

    _gameState = _gameState.copyWith(status: GameStatus.swapping, message: null);
    state = AsyncValue.data(state.value!.copyWith(board: _deepCopyBoard(state.value!.board, state.value!.size))); // Trigger UI update for swap animation

    final GameBoard boardAfterSwap = await ref.read(gameRepositoryProvider).swapCandies(state.value!, candy1, candy2);

    // Check for matches after swap
    final Map<String, dynamic> matchResult = await ref.read(gameRepositoryProvider).processMatches(boardAfterSwap);
    final int scoreIncrease = matchResult['scoreIncrease'] as int;

    if (scoreIncrease > 0) {
      // Valid move, update board and process matches
      _gameState = _gameState.copyWith(
        score: _gameState.score + scoreIncrease,
        movesLeft: _gameState.movesLeft - 1,
        status: GameStatus.matching,
      );
      state = AsyncValue.data(matchResult['board'] as GameBoard); // Board with nulls for matched candies

      await Future.delayed(const Duration(milliseconds: 300)); // Animation delay for matches

      await _processBoardChanges(); // Process falling and refilling
    } else {
      // Invalid move, swap back
      _gameState = _gameState.copyWith(movesLeft: _gameState.movesLeft - 1, message: 'No match, try again!');
      state = AsyncValue.data(await ref.read(gameRepositoryProvider).swapCandies(boardAfterSwap, candy1, candy2)); // Swap back
      await Future.delayed(const Duration(milliseconds: 200)); // Animation delay for swap back
    }

    _checkGameOver();
    _gameState = _gameState.copyWith(status: GameStatus.playing, message: null);
  }

  bool _isAdjacent(Candy candy1, Candy candy2) {
    final int rowDiff = (candy1.row - candy2.row).abs();
    final int colDiff = (candy1.col - candy2.col).abs();
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }

  Future<void> _processBoardChanges() async {
    GameBoard currentBoard = state.value!;
    int totalScoreIncrease = 0;

    do {
      // 1. Candies fall and board refills
      _gameState = _gameState.copyWith(status: GameStatus.falling);
      currentBoard = await ref.read(gameRepositoryProvider).refillBoard(currentBoard);
      state = AsyncValue.data(currentBoard);
      await Future.delayed(const Duration(milliseconds: 400)); // Animation delay for falling/refilling

      // 2. Check for new matches
      _gameState = _gameState.copyWith(status: GameStatus.matching);
      final Map<String, dynamic> matchResult = await ref.read(gameRepositoryProvider).processMatches(currentBoard);
      final int scoreIncrease = matchResult['scoreIncrease'] as int;
      final List<Candy> matchedCandies = matchResult['matchedCandies'] as List<Candy>;

      if (scoreIncrease > 0) {
        totalScoreIncrease += scoreIncrease;
        _gameState = _gameState.copyWith(score: _gameState.score + scoreIncrease);
        currentBoard = matchResult['board'] as GameBoard; // Board with nulls for new matches
        state = AsyncValue.data(currentBoard);
        await Future.delayed(const Duration(milliseconds: 300)); // Animation delay for matches
      } else {
        break; // No more matches, stop the loop
      }
    } while (true);

    _gameState = _gameState.copyWith(status: GameStatus.playing);
    state = AsyncValue.data(currentBoard); // Final board state
  }

  void _checkGameOver() {
    if (_gameState.movesLeft <= 0) {
      _gameState = _gameState.copyWith(status: GameStatus.gameOver, message: 'Game Over!');
      _saveHighScore(_gameState.score);
    } else if (!ref.read(gameRepositoryProvider).hasPossibleMoves(state.value!)) {
      _gameState = _gameState.copyWith(status: GameStatus.gameOver, message: 'No more moves! Game Over!');
      _saveHighScore(_gameState.score);
    }
  }

  Future<void> _saveHighScore(int score) async {
    if (score > 0) {
      final String playerName = 'Player${Random().nextInt(1000)}'; // Simple placeholder name
      final ScoreEntry newScore = ScoreEntry(
        id: UniqueKey().toString(),
        playerName: playerName,
        score: score,
        date: DateTime.now(),
      );
      await ref.read(scoreRepositoryProvider).addHighScore(newScore);
    }
  }

  List<List<Candy?>> _deepCopyBoard(List<List<Candy?>> original, int size) {
    return List.generate(
      size,
      (r) => List.generate(
        size,
        (c) => original[r][c]?.copyWith(),
      ),
    );
  }
}

final gameControllerProvider = AsyncNotifierProvider<GameController, GameBoard>(
  GameController.new,
);

final gameStateProvider = Provider<GameState>((ref) {
  return ref.watch(gameControllerProvider.notifier).gameState;
});

final selectedCandyProvider = Provider<Candy?>((ref) {
  return ref.watch(gameControllerProvider.notifier).selectedCandy;
});
