import 'package:canddy_app/features/game/domain/entities/candy.dart';

class GameBoard {
  final List<Candy?> candies;

  const GameBoard({required this.candies});

  GameBoard copyWith({
    List<Candy?>? candies,
  }) {
    return GameBoard(
      candies: candies ?? this.candies,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameBoard &&
          runtimeType == other.runtimeType &&
          candies == other.candies;

  @override
  int get hashCode => candies.hashCode;

  @override
  String toString() => 'GameBoard(candies: $candies)';
}
