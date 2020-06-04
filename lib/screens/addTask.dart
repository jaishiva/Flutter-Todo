import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo/constants.dart';
import 'package:todoo/customWidgets.dart';
import 'package:intl/intl.dart';
import 'package:todoo/model/taskDataProvider.dart';

class AddNewTask extends StatefulWidget {
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  String task;
  String _dateTime;
  String time;
  String duration;
  TaskDataProvider _taskDataProvider = TaskDataProvider();
  TextEditingController _textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: kBrightOrange, borderRadius: BorderRadius.circular(25)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned(
              child: CircleAvatar(
                backgroundColor: kRed,
                radius: 100,
              ),
              right: -100,
              top: -60,
            ),
            Positioned(
              child: Opacity(
                  opacity: 0.5,
                  child: CircleAvatar(
                    backgroundColor: kPink,
                    radius: 120,
                  )),
              right: -20,
              top: -160,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);})
                    Text(
                      'Create \nNew Task',
                      style: kBlackMediumPlain,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Task'),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _textEditingController,
                      textAlign: TextAlign.center,
                      onChanged: (value) => task = value,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text('Date'),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: kBlack, width: 1))),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          _dateTime == null ? '' : _dateTime,
                          style: kBlackSmallPlain,
                        ),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.date_range,
                              color: kBlack,
                            ),
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: startDate,
                                      lastDate: endDate)
                                  .then((value) {
                                setState(() {
                                  _dateTime = DateFormat.yMMMMd()
                                      .format(value)
                                      .toString();
                                });
                              });
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text('Time and Duration'),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: kBlack, width: 1))),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          time == null ? '' : '$time for $duration hrs',
                          style: kBlackSmallPlain,
                        ),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.timer,
                              color: kBlack,
                            ),
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: 1, minute: 0),
                                builder:
                                      (BuildContext context, Widget child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child,
                                    );
                                  },
                              ).then((value) {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 1, minute: 0),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child,
                                    );
                                  },
                                ).then((value1) {
                                  setState(() {
                                    duration =
                                        '${value1.hour}:${value1.minute}';
                                    time = '${value.hour}:${value.minute}';
                                  });
                                });
                              });
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CupertinoButton(
                        color: kDarkBlue,
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'CREATE TASK',
                              style: kWhiteSmallPlain,
                            )
                          ],
                        ),
                        onPressed: () async {
                          if (task != null &&
                              time != null &&
                              _dateTime != null) {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: 300,
                                    height: 300,
                                    child: Text('Adding Task'),
                                  );
                                });
                            await _taskDataProvider.addNewTask({
                              'date': _dateTime,
                              'time': time,
                              'duration': duration,
                              'task': task,
                              'status': 0,
                            }).whenComplete(() {
                              Navigator.pop(context);
                            });
                            Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Task Created Successfully',textAlign: TextAlign.center,),elevation: 5,duration: Duration(milliseconds: 800),)
                            );
                            setState(() {
                            duration = null;
                            task = null;
                            time = null;
                            _dateTime = null;
                            _textEditingController.clear();
                          });
                          }
                          else{
       
                            Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill in all the fields',textAlign: TextAlign.center,),elevation: 5,duration: Duration(milliseconds: 800),)
                            );
                          }
                          
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
