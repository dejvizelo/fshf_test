import 'package:flutter/material.dart';

class CompetitionListTile extends StatelessWidget {

  String competition, date;
  int round;

  CompetitionListTile({this.competition, this.date, this.round});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.black12,
      child: Row(
        children: [
          Text(
            competition,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
          Text(
            " / $date / JAVA: $round",
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
