import 'package:flutter/material.dart';
import 'dart:math';

enum CandyType {
  red,
  blue,
  green,
  yellow,
  purple,
  orange,
}

extension CandyTypeExtension on CandyType {
  Color get color {
    switch (this) {
      case CandyType.red:
        return Colors.red.shade400;
      case CandyType.blue:
        return Colors.blue.shade400;
      case CandyType.green:
        return Colors.green.shade400;
      case CandyType.yellow:
        return Colors.yellow.shade400;
      case CandyType.purple:
        return Colors.purple.shade400;
      case CandyType.orange:
        return Colors.orange.shade400;
    }
  }

  IconData get icon {
    switch (this) {
      case CandyType.red:
        return Icons.circle;
      case CandyType.blue:
        return Icons.square;
      case CandyType.green:
        return Icons.star;
      case CandyType.yellow:
        return Icons.diamond;
      case CandyType.purple:
        return Icons.hexagon;
      case CandyType.orange:
        return Icons.pentagon;
    }
  }
}

class Candy {
  final String id;
  final CandyType type;
  final int row;
  final int col;

  Candy({
    required this.id,
    required this.type,
    required this.row,
    required this.col,
  });

  Candy copyWith({
    String? id,
    CandyType? type,
    int? row,
    int? col,
  }) {
    return Candy(
      id: id ?? this.id,
      type: type ?? this.type,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  static Candy generateRandom(int row, int col) {
    final random = Random();
    final type = CandyType.values[random.nextInt(CandyType.values.length)];
    return Candy(id: UniqueKey().toString(), type: type, row: row, col: col);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Candy &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Candy(id: $id, type: $type, row: $row, col: $col)';
}
