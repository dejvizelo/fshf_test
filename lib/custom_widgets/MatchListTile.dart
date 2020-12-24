import 'package:flutter/material.dart';

class MatchListTile extends StatefulWidget {

  String team1, team2, emblemTeam1, emblemTeam2, matchMin, score1, score2;

  static final intRegex = RegExp(r'(\d+)\D+(\d+)');

  MatchListTile({
    this.team1,
    this.team2,
    this.emblemTeam1,
    this.emblemTeam2,
    this.matchMin,
    this.score1,
    this.score2
  });

  factory MatchListTile.fromJson(Map<String, dynamic> json) {
    bool hasEmptyScore = intRegex.allMatches(json['ft_result']).isEmpty;

    return MatchListTile(
      team1: json['home_team'],
      team2: json['away_team'],
      emblemTeam1: json['home_team_flag'],
      emblemTeam2: json['away_team_flag'],
      matchMin: json['match_minute'],
      score1: !hasEmptyScore ? intRegex.allMatches(json['ft_result']).map((m) => m.group(1)).elementAt(0) : "-",
      score2: !hasEmptyScore ? intRegex.allMatches(json['ft_result']).map((m) => m.group(2)).elementAt(0) : "-"
    );
  }

  @override
  _MatchListTileState createState() => _MatchListTileState();
}

class _MatchListTileState extends State<MatchListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(this.widget.emblemTeam1, height: 25, width: 25),
                  Container(
                    child: Text(this.widget.team1),
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  )
                ],
              ),
              Container(height: 5),
              Row(
                children: [
                  Image.network(this.widget.emblemTeam2, height: 25, width: 25),
                  Container(
                    child: Text(this.widget.team2),
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Text(
                widget.matchMin,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 35,
                child: Column(
                  children: [
                    Container(
                        child: Text(widget.score1.toString()),
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0)
                    ),
                    Divider( // for some reason this does not show up
                      color: Colors.red,
                      height: 16,
                      thickness: 1,
                    ),
                    Container(
                        child: Text(widget.score2.toString()),
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 8)
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
