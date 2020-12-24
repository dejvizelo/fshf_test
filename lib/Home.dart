import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
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
          leading: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset("assets/logo.png"),
          ),
          leadingWidth: 80,
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'REZULTATE ',
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 23)
                ),
                TextSpan(
                    text: 'LIVE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)
                )
              ],
            ),
          ),
          centerTitle: true,
          flexibleSpace: Image(
            image: AssetImage('assets/cover-mobile.jpg'),
            fit: BoxFit.cover,
            color: Colors.red,
            colorBlendMode: BlendMode.modulate
          ),
          toolbarHeight: 70,
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
                    shape: CustomRoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                      ),
                      leftSide: BorderSide(color: Colors.red),
                      topSide: BorderSide(color: Colors.red),
                      bottomSide: BorderSide(color: Colors.red),
                      topLeftCornerSide: BorderSide(color: Colors.red),
                      bottomLeftCornerSide: BorderSide(color: Colors.red)
                    ),
                    minWidth: 60,
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
                      shape: CustomRoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          leftSide: BorderSide(color: Colors.red),
                          rightSide: BorderSide(color: Colors.red),
                          topSide: BorderSide(color: Colors.red),
                          bottomSide: BorderSide(color: Colors.red),
                          topRightCornerSide: BorderSide(color: Colors.red),
                          bottomRightCornerSide: BorderSide(color: Colors.red)
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
