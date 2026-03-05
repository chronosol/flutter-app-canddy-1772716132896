import 'package:intl/intl.dart';

class ScoreEntry {
  final String id;
  final String playerName;
  final int score;
  final DateTime date;

  ScoreEntry({
    required this.id,
    required this.playerName,
    required this.score,
    required this.date,
  });

  ScoreEntry copyWith({
    String? id,
    String? playerName,
    int? score,
    DateTime? date,
  }) {
    return ScoreEntry(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      score: score ?? this.score,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerName': playerName,
      'score': score,
      'date': date.toIso8601String(),
    };
  }

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      id: json['id'] as String,
      playerName: json['playerName'] as String,
      score: json['score'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  String get formattedDate => DateFormat('yyyy-MM-dd HH:mm').format(date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ScoreEntry(playerName: $playerName, score: $score, date: $date)';
}
