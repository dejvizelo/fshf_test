import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouped_list/grouped_list.dart';
import 'DataManager.dart';
import 'package:fshf_test/custom_widgets/CompetitionListTile.dart';
import 'package:fshf_test/custom_widgets/MatchListTile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        matchesFuture = _getMatches();
      });
  }

  Future matchesFuture;

  @override
  void initState() {
    super.initState();
    matchesFuture = _getMatches();
  }

  _getMatches() async {
    return await DataManager().matchList("${selectedDate.toLocal()}".split(' ')[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("REZULTATE LIVE"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: null,
                    child: Text("LIVE"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)
                        ),
                        side: BorderSide(color: Colors.red, width: 1)
                    ),
                  ),
                  FlatButton(
                      onPressed: Platform.isAndroid
                          ? () => _selectDate(context)
                          : () => showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 250,
                                child: CupertinoDatePicker(
                                  backgroundColor: Colors.white,
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: selectedDate,
                                  minimumYear: 2015,
                                  maximumYear: 2022,
                                  onDateTimeChanged: (dateTime) {
                                    if (dateTime != null && dateTime != selectedDate)
                                    setState(() {
                                      selectedDate = dateTime;
                                      matchesFuture = _getMatches();
                                    });
                                  },
                                ),
                              );
                            }
                          ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          side: BorderSide(color: Colors.red, width: 1)
                      ),
                      child: Text("${selectedDate.toLocal()}".split(' ')[0])
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: matchesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                      child: snapshot.data == null
                          ? Column(
                              children: [
                                Icon(
                                  Icons.sports_soccer_sharp,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Nuk ka ndeshje per daten " + "${selectedDate.toLocal()}".split(' ')[0],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                  ),
                                ),
                              ],
                            )
                          : GroupedListView<dynamic, String>(
                              elements: snapshot.data,
                              groupBy: (item) => item['competition_name'],
                              groupHeaderBuilder: (item) {
                                return CompetitionListTile(
                                  competition: item['competition_name'],
                                  date:
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                  round: int.parse(item['round_number']),
                                );
                              },
                              itemBuilder: (context, item) {
                                return MatchListTile.fromJson(item);
                              },
                              separator: Divider(height: 1),
                              order: GroupedListOrder.DESC,
                              useStickyGroupSeparators: true,
                              shrinkWrap: true,
                            ),
                    );
                  } else {
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                }
            )
          ],
        )
    );
  }
}
