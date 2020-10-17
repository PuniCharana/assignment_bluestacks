// https://api.mocki.io/v1/299cebe5
class User {
  String name;
  String avatar;
  int points;
  int tournamentsWon;
  int tournamentsPlayed;
  int winningPercentage;

  User(
      {this.name,
        this.avatar,
        this.points,
        this.tournamentsWon,
        this.tournamentsPlayed,
        this.winningPercentage});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    points = json['points'];
    tournamentsWon = json['tournaments_won'];
    tournamentsPlayed = json['tournaments_played'];
    winningPercentage = json['winning_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['points'] = this.points;
    data['tournaments_won'] = this.tournamentsWon;
    data['tournaments_played'] = this.tournamentsPlayed;
    data['winning_percentage'] = this.winningPercentage;
    return data;
  }
}