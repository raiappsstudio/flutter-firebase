class FootballScore {
  final String matchName;
  final bool is_running;
  final String team1_name;
  final int team1_score;
  final String team2_name;
  final int team2_score;
  final String winner;

  FootballScore({
    required this.is_running,
    required this.team1_name,
    required this.team1_score,
    required this.team2_name,
    required this.team2_score,
    required this.winner,
    required this.matchName });

  factory FootballScore.fromJson(Map<String, dynamic> json, String matchname) {
    return FootballScore(
        is_running: json['is_running'],
        team1_name: json['team1_name'],
        team1_score: json['team1_score'],
        team2_name: json['team2_name'],
        team2_score: json['team2_score'],
        winner: json['winner'] ?? '',
        matchName: matchname,

    );
  }
}
