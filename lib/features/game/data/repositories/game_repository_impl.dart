import 'dart:math';

import 'package:canddy/core/constants/app_constants.dart';
import 'package:canddy/features/game/domain/entities/candy.dart';
import 'package:canddy/features/game/domain/entities/game_board.dart';
import 'package:canddy/features/game/domain/repositories/game_repository.dart';
import 'package:flutter/material.dart'; // For UniqueKey

class GameRepositoryImpl implements GameRepository {
  final Random _random = Random();

  @override
  GameBoard initializeBoard(int size) {
    final List<List<Candy?>> board = List.generate(
      size,
      (row) => List.generate(
        size,
        (col) => null,
      ),
    );

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        board[r][c] = _generateUniqueCandy(board, r, c, size);
      }
    }
    return GameBoard(board: board, size: size);
  }

  Candy _generateUniqueCandy(
      List<List<Candy?>> board, int row, int col, int size) {
    CandyType type;
    do {
      type = CandyType.values[_random.nextInt(CandyType.values.length)];
    } while (
        _isMatchAtCreation(board, row, col, type, size)); // Avoid initial matches
    return Candy(id: UniqueKey().toString(), type: type, row: row, col: col);
  }

  bool _isMatchAtCreation(
      List<List<Candy?>> board, int row, int col, CandyType type, int size) {
    // Check horizontal match
    if (col >= 2 &&
        board[row][col - 1]?.type == type &&
        board[row][col - 2]?.type == type) {
      return true;
    }
    // Check vertical match
    if (row >= 2 &&
        board[row - 1][col]?.type == type &&
        board[row - 2][col]?.type == type) {
      return true;
    }
    return false;
  }

  @override
  Future<GameBoard> swapCandies(GameBoard board, Candy candy1, Candy candy2) async {
    final newBoard = _deepCopyBoard(board.board, board.size);

    // Find positions
    final int r1 = candy1.row;
    final int c1 = candy1.col;
    final int r2 = candy2.row;
    final int c2 = candy2.col;

    // Perform swap
    newBoard[r1][c1] = candy2.copyWith(row: r1, col: c1);
    newBoard[r2][c2] = candy1.copyWith(row: r2, col: c2);

    return GameBoard(board: newBoard, size: board.size);
  }

  @override
  Future<Map<String, dynamic>> processMatches(GameBoard board) async {
    final List<List<Candy?>> currentBoard = _deepCopyBoard(board.board, board.size);
    final Set<Candy> matchedCandies = {};
    int scoreIncrease = 0;

    // Check horizontal matches
    for (int r = 0; r < board.size; r++) {
      for (int c = 0; c <= board.size - AppConstants.minMatchLength; c++) {
        final Candy? firstCandy = currentBoard[r][c];
        if (firstCandy == null) continue;

        final List<Candy> currentMatch = [firstCandy];
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (currentBoard[r][c + k]?.type == firstCandy.type) {
            currentMatch.add(currentBoard[r][c + k]!);
          } else {
            break;
          }
        }

        if (currentMatch.length >= AppConstants.minMatchLength) {
          matchedCandies.addAll(currentMatch);
        }
      }
    }

    // Check vertical matches
    for (int c = 0; c < board.size; c++) {
      for (int r = 0; r <= board.size - AppConstants.minMatchLength; r++) {
        final Candy? firstCandy = currentBoard[r][c];
        if (firstCandy == null) continue;

        final List<Candy> currentMatch = [firstCandy];
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (currentBoard[r + k][c]?.type == firstCandy.type) {
            currentMatch.add(currentBoard[r + k][c]!);
          }
          else {
            break;
          }
        }

        if (currentMatch.length >= AppConstants.minMatchLength) {
          matchedCandies.addAll(currentMatch);
        }
      }
    }

    if (matchedCandies.isNotEmpty) {
      scoreIncrease = matchedCandies.length * AppConstants.scorePerCandy;
      // Remove matched candies
      for (final candy in matchedCandies) {
        currentBoard[candy.row][candy.col] = null;
      }
    }

    return {
      'board': GameBoard(board: currentBoard, size: board.size),
      'scoreIncrease': scoreIncrease,
      'matchedCandies': matchedCandies.toList(),
    };
  }

  @override
  Future<GameBoard> refillBoard(GameBoard board) async {
    final List<List<Candy?>> currentBoard = _deepCopyBoard(board.board, board.size);

    // 1. Make candies fall
    for (int c = 0; c < board.size; c++) {
      int emptyRow = board.size - 1;
      for (int r = board.size - 1; r >= 0; r--) {
        if (currentBoard[r][c] != null) {
          if (r != emptyRow) {
            currentBoard[emptyRow][c] = currentBoard[r][c]!.copyWith(row: emptyRow, col: c);
            currentBoard[r][c] = null;
          }
          emptyRow--;
        }
      }
    }

    // 2. Fill empty spots with new candies
    for (int r = 0; r < board.size; r++) {
      for (int c = 0; c < board.size; c++) {
        if (currentBoard[r][c] == null) {
          currentBoard[r][c] = Candy.generateRandom(r, c);
        }
      }
    }

    return GameBoard(board: currentBoard, size: board.size);
  }

  @override
  bool hasPossibleMoves(GameBoard board) {
    final List<List<Candy?>> currentBoard = board.board;
    final int size = board.size;

    // Check for horizontal swaps that create a match
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size - 1; c++) {
        // Temporarily swap
        final Candy? temp1 = currentBoard[r][c];
        final Candy? temp2 = currentBoard[r][c + 1];
        if (temp1 == null || temp2 == null) continue;

        currentBoard[r][c] = temp2.copyWith(row: r, col: c);
        currentBoard[r][c + 1] = temp1.copyWith(row: r, col: c + 1);

        if (_checkAnyMatch(currentBoard, size)) {
          // Swap back
          currentBoard[r][c] = temp1;
          currentBoard[r][c + 1] = temp2;
          return true;
        }
        // Swap back
        currentBoard[r][c] = temp1;
        currentBoard[r][c + 1] = temp2;
      }
    }

    // Check for vertical swaps that create a match
    for (int r = 0; r < size - 1; r++) {
      for (int c = 0; c < size; c++) {
        // Temporarily swap
        final Candy? temp1 = currentBoard[r][c];
        final Candy? temp2 = currentBoard[r + 1][c];
        if (temp1 == null || temp2 == null) continue;

        currentBoard[r][c] = temp2.copyWith(row: r, col: c);
        currentBoard[r + 1][c] = temp1.copyWith(row: r + 1, col: c);

        if (_checkAnyMatch(currentBoard, size)) {
          // Swap back
          currentBoard[r][c] = temp1;
          currentBoard[r + 1][c] = temp2;
          return true;
        }
        // Swap back
        currentBoard[r][c] = temp1;
        currentBoard[r + 1][c] = temp2;
      }
    }

    return false;
  }

  bool _checkAnyMatch(List<List<Candy?>> board, int size) {
    // Check horizontal matches
    for (int r = 0; r < size; r++) {
      for (int c = 0; c <= size - AppConstants.minMatchLength; c++) {
        final Candy? firstCandy = board[r][c];
        if (firstCandy == null) continue;

        bool match = true;
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (board[r][c + k]?.type != firstCandy.type) {
            match = false;
            break;
          }
        }
        if (match) return true;
      }
    }

    // Check vertical matches
    for (int c = 0; c < size; c++) {
      for (int r = 0; r <= size - AppConstants.minMatchLength; r++) {
        final Candy? firstCandy = board[r][c];
        if (firstCandy == null) continue;

        bool match = true;
        for (int k = 1; k < AppConstants.minMatchLength; k++) {
          if (board[r + k][c]?.type != firstCandy.type) {
            match = false;
            break;
          }
        }
        if (match) return true;
      }
    }
    return false;
  }

  List<List<Candy?>> _deepCopyBoard(List<List<Candy?>> original, int size) {
    return List.generate(
      size,
      (r) => List.generate(
        size,
        (c) => original[r][c]?.copyWith(), // Copy each candy
      ),
    );
  }
}
