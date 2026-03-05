import 'package:flutter/material.dart';

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
      case CandyType.red: return Colors.red.shade400;
      case CandyType.blue: return Colors.blue.shade400;
      case CandyType.green: return Colors.green.shade400;
      case CandyType.yellow: return Colors.yellow.shade400;
      case CandyType.purple: return Colors.purple.shade400;
      case CandyType.orange: return Colors.orange.shade400;
    }
  }
}

class Candy {
  final CandyType type;
  final String id; // Unique ID for animations

  Candy({required this.type}) : id = UniqueKey().toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Candy && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Candy(type: $type, id: $id)';
}
