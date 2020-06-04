
import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:todoo/model/taskDataProvider.dart';
const TextStyle dateStyle = TextStyle(
  color: Colors.white,
  fontSize: 24,
  letterSpacing: 1.7,
  fontWeight: FontWeight.w700
);
const TextStyle kBlackMediumPlain = TextStyle(
    color: Colors.black,
    fontSize: 24,
    letterSpacing: 1.7,
    fontWeight: FontWeight.w400
);

const TextStyle kBlackSmallPlain = TextStyle(
    color: Colors.black,
    fontSize: 18,
    letterSpacing: 1.7,
    fontWeight: FontWeight.w400
);

const TextStyle kWhiteMediumPlain = TextStyle(
    color: Colors.white,
    fontSize: 24,
    letterSpacing: 1.7,
    fontWeight: FontWeight.w400
);

const TextStyle kWhiteSmallPlain = TextStyle(
    color: Colors.white,
    fontSize: 18,
    letterSpacing: 1.7,
    fontWeight: FontWeight.w400
);

const TextStyle weekdayStyle = TextStyle(
  color: Colors.white,
  fontSize: 14
);
 
double width1;
double height1;
const kOrange = Color(0xffFFE4D4);
const kBrightOrange = Color(0xfffbe5d6);
const kPink = Color(0xfff783b8);
const kRed = Color(0xffd34257);
const kBlack = Colors.black;
const kTileColor = Color(0xff4597a1);
const backgroundColor = Color(0xfff9f3f0);
const kDarkBlue = Color(0xff455190);

DateTime startDate = DateTime.now().subtract(Duration(days: 365));
  DateTime endDate = DateTime.now().add(Duration(days: 365));
  // DateTime selectedDate = DateTime.now();
  

  onSelect(data) {
    print("Selected Date -> $data");
  }

  monthNameWidget(monthName) {
    return Container(
      child: Text(monthName,
          style:
              TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
      padding: EdgeInsets.only(top: 8, bottom: 15),
    );
  }

  getMarkedIndicatorWidget(Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          margin: EdgeInsets.only(left: 1, right: 1),
          width: 7,
          height: 7,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: color),
        ),
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
        )
      ]),
    );
  }

  dateTileBuilder(date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.white54 : Colors.white;
    TextStyle normalStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black);
    TextStyle dayNameselectedStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black);

    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style:!isSelectedDate ?  dayNameStyle: dayNameselectedStyle),
      Text(date.day.toString(), style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget(Colors.black));
    }
    else{
      _children.add(getMarkedIndicatorWidget(Colors.transparent));
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _children,
      ),
    );
  }