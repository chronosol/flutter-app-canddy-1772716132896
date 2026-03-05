import 'dart:math';

import 'package:canddy_app/core/constants/app_constants.dart';
import 'package:canddy_app/features/game/domain/entities/candy.dart';
import 'package:canddy_app/features/game/domain/entities/game_board.dart';
import 'package:canddy_app/features/game/domain/entities/game_state.dart';
import 'package:canddy_app/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final Random _random = Random();

  @override
  Future<GameState> initializeGame() async {
    final board = _generateInitialBoard();
    return GameState(
      board: board,
      score: 0,
      movesLeft: AppConstants.initialMoves,
      isGameOver: false,
    );
  }

  @override
  Future<GameState> makeMove(GameState currentState, int index1, int index2) async {
    if (currentState.isGameOver || currentState.movesLeft <= 0) {
      return currentState;
    }

    final newBoard = List<Candy?>.from(currentState.board.candies);
    final int size = AppConstants.boardSize;

    final int row1 = index1 ~/ size;
    (final int col1 = index1 % size).toInt();
    final int row2 = index2 ~/ size;
    (final int col2 = index2 % size).toInt();

    // Check if candies are adjacent
    final bool isAdjacent = (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);

    if (!isAdjacent) {
      return currentState; // Not an adjacent move
    }

    // Swap candies
    final temp = newBoard[index1];
    newBoard[index1] = newBoard[index2];
    newBoard[index2] = temp;

    int newScore = currentState.score;
    int movesLeft = currentState.movesLeft - 1;

    // Process matches
    List<int> matchedIndices = _findMatches(GameBoard(candies: newBoard));
    if (matchedIndices.isNotEmpty) {
      newScore += matchedIndices.length * AppConstants.scorePerCandy;
      _clearCandies(newBoard, matchedIndices);
      _gravity(newBoard);
      _fillEmptySpaces(newBoard);

      // Recursively check for new matches after gravity/fill
      List<int> cascadeMatches;
      do {
        cascadeMatches = _findMatches(GameBoard(candies: newBoard));
        if (cascadeMatches.isNotEmpty) {
          newScore += cascadeMatches.length * AppConstants.scorePerCandy;
          _clearCandies(newBoard, cascadeMatches);
          _gravity(newBoard);
          _fillEmptySpaces(newBoard);
        }
      } while (cascadeMatches.isNotEmpty);
    } else {
      // If no match, revert the swap
      final temp = newBoard[index1];
      newBoard[index1] = newBoard[index2];
      newBoard[index2] = temp;
      movesLeft++; // Don't consume a move if no match
    }

    final bool isGameOver = movesLeft <= 0 && !_hasPossibleMoves(GameBoard(candies: newBoard));

    return currentState.copyWith(
      board: GameBoard(candies: newBoard),
      score: newScore,
      movesLeft: movesLeft,
      isGameOver: isGameOver,
    );
  }

  List<Candy?> _generateInitialBoard() {
    final int size = AppConstants.boardSize;
    final List<Candy?> candies = List.generate(size * size, (index) => _generateRandomCandy());

    // Ensure no initial matches
    bool hasMatches;
    do {
      hasMatches = false;
      for (int i = 0; i < candies.length; i++) {
        final int row = i ~/ size;
        (final int col = i % size).toInt();

        // Check horizontal matches
        if (col >= 2 &&
            candies[i]?.type == candies[i - 1]?.type &&
            candies[i]?.type == candies[i - 2]?.type) {
          candies[i] = _generateRandomCandy(exclude: candies[i]?.type);
          hasMatches = true;
        }
        // Check vertical matches
        if (row >= 2 &&
            candies[i]?.type == candies[i - size]?.type &&
            candies[i]?.type == candies[i - 2 * size]?.type) {
          candies[i] = _generateRandomCandy(exclude: candies[i]?.type);
          hasMatches = true;
        }
      }
    } while (hasMatches);

    return candies;
  }

  Candy _generateRandomCandy({CandyType? exclude}) {
    CandyType type;
    do {
      type = CandyType.values[_random.nextInt(CandyType.values.length)];
    } while (type == exclude);
    return Candy(type: type);
  }

  List<int> _findMatches(GameBoard board) {
    final int size = AppConstants.boardSize;
    final List<int> matchedIndices = [];

    // Check horizontal matches
    for (int row = 0; row < size; row++) {
      for (int col = 0; col <= size - AppConstants.minMatchLength; col++) {
        final Candy? firstCandy = board.candies[row * size + col];
        if (firstCandy == null) continue;

        int matchCount = 1;
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (board.candies[row * size + col + k]?.type == firstCandy.type) {
            matchCount++;
          } else {
            break;
          }
        }
        if (matchCount >= AppConstants.minMatchLength) {
          for (int k = 0; k < matchCount; k++) {
            matchedIndices.add(row * size + col + k);
          }
        }
      }
    }

    // Check vertical matches
    for (int col = 0; col < size; col++) {
      for (int row = 0; row <= size - AppConstants.minMatchLength; row++) {
        final Candy? firstCandy = board.candies[row * size + col];
        if (firstCandy == null) continue;

        int matchCount = 1;
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (board.candies[(row + k) * size + col]?.type == firstCandy.type) {
            matchCount++;
          } else {
            break;
          }
        }
        if (matchCount >= AppConstants.minMatchLength) {
          for (int k = 0; k < matchCount; k++) {
            matchedIndices.add((row + k) * size + col);
          }
        }
      }
    }

    return matchedIndices.toSet().toList(); // Remove duplicates
  }

  void _clearCandies(List<Candy?> candies, List<int> indicesToClear) {
    for (final index in indicesToClear) {
      candies[index] = null;
    }
  }

  void _gravity(List<Candy?> candies) {
    final int size = AppConstants.boardSize;
    for (int col = 0; col < size; col++) {
      int writeIndex = size * size - 1 - col; // Start from bottom of column
      for (int row = size - 1; row >= 0; row--) {
        final int readIndex = row * size + col;
        if (candies[readIndex] != null) {
          candies[writeIndex] = candies[readIndex];
          if (readIndex != writeIndex) {
            candies[readIndex] = null;
          }
          writeIndex -= size;
        }
      }
      // Fill remaining top spots with nulls if column wasn't full
      while (writeIndex >= 0 && (writeIndex % size) == col) {
        candies[writeIndex] = null;
        writeIndex -= size;
      }
    }
  }

  void _fillEmptySpaces(List<Candy?> candies) {
    final int size = AppConstants.boardSize;
    for (int i = 0; i < candies.length; i++) {
      if (candies[i] == null) {
        candies[i] = _generateRandomCandy();
      }
    }
  }

  bool _hasPossibleMoves(GameBoard board) {
    final int size = AppConstants.boardSize;
    final List<Candy?> candies = board.candies;

    // Check for horizontal swaps
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size - 1; col++) {
        final int index1 = row * size + col;
        final int index2 = row * size + col + 1;

        // Temporarily swap
        final temp = candies[index1];
        candies[index1] = candies[index2];
        candies[index2] = temp;

        if (_findMatches(GameBoard(candies: candies)).isNotEmpty) {
          // Revert swap
          final temp = candies[index1];
          candies[index1] = candies[index2];
          candies[index2] = temp;
          return true;
        }
        // Revert swap
        final temp2 = candies[index1];
        candies[index1] = candies[index2];
        candies[index2] = temp2;
      }
    }

    // Check for vertical swaps
    for (int col = 0; col < size; col++) {
      for (int row = 0; row < size - 1; row++) {
        final int index1 = row * size + col;
        final int index2 = (row + 1) * size + col;

        // Temporarily swap
        final temp = candies[index1];
        candies[index1] = candies[index2];
        candies[index2] = temp;

        if (_findMatches(GameBoard(candies: candies)).isNotEmpty) {
          // Revert swap
          final temp = candies[index1];
          candies[index1] = candies[index2];
          candies[index2] = temp;
          return true;
        }
        // Revert swap
        final temp2 = candies[index1];
        candies[index1] = candies[index2];
        candies[index2] = temp2;
      }
    }

    return false;
  }
}

final gameRepositoryProvider = Provider<GameRepository>((ref) => GameRepositoryImpl());
