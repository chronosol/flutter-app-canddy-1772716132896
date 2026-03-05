class ScoreEntry {
  final String playerName;
  final int score;
  final DateTime date;

  const ScoreEntry({
    required this.playerName,
    required this.score,
    required this.date,
  });

  ScoreEntry copyWith({
    String? playerName,
    int? score,
    DateTime? date,
  }) {
    return ScoreEntry(
      playerName: playerName ?? this.playerName,
      score: score ?? this.score,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'score': score,
        'date': date.toIso8601String(),
      };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
        playerName: json['playerName'] as String,
        score: json['score'] as int,
        date: DateTime.parse(json['date'] as String),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreEntry &&
          runtimeType == other.runtimeType &&
          playerName == other.playerName &&
          score == other.score &&
          date == other.date;

  @override
  int get hashCode => playerName.hashCode ^ score.hashCode ^ date.hashCode;

  @override
  String toString() =>
      'ScoreEntry(playerName: $playerName, score: $score, date: $date)';
}
