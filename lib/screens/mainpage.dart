import 'package:calendar_strip/calendar_strip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoo/model/taskDataProvider.dart';
import 'package:todoo/screens/DayPage.dart';
import '../constants.dart';
import '../customWidgets.dart';
import 'InitialPage.dart';

class MainPage extends StatelessWidget {

  TaskDataProvider _taskDataProvider;
  String date = DateFormat('MMMM d, yyyy', 'en_US').format(DateTime.now());



  @override
  Widget build(BuildContext context) {
    // _taskDataProvider = Provider.of<TaskDataProvider>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            child: ClipRRect(
              clipper: CustomRect(),
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  CustomShader(
                    child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(color: kRed)),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    clipper: CustomRect(),
                    child: Transform.translate(
                      offset: Offset(0, -240),
                      child: CircleAvatar(
                        maxRadius: 200,
                        backgroundColor: kBlack,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    clipper: CustomRect(),
                    child: Transform.translate(
                      offset: Offset(-50, -130),
                      child: CircleAvatar(
                        minRadius: 110,
                        backgroundColor: kRed,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      padding: EdgeInsets.only(top: 15),
                      child: Consumer<TaskDataProvider>(
                                              builder:(context, value, child) =>  CalendarStrip(
                          startDate: startDate,
                          endDate: endDate,
                          onDateSelected: (data){
                              value.changeSelectedDate(data); 
                          },
                          dateTileBuilder: dateTileBuilder,
                          iconColor: Colors.white,
                          monthNameWidget: monthNameWidget,
                          markedDates: markedDates,
                          containerDecoration:
                              BoxDecoration(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Consumer<TaskDataProvider>(
                builder: (context, value, child) => InitialPage(date: selectedDate,))
            ),
          )
        ],
      ),
    );
  }
}
