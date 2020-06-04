import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoo/constants.dart';
import 'package:todoo/customWidgets.dart';
import 'package:todoo/model/taskDataProvider.dart';

class InitialPage extends StatefulWidget {
  final String date;

  InitialPage({Key key, this.date}) : super(key: key);
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  TaskDataProvider _taskDataProvider ;
  bool spinner = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskDataProvider = Provider.of<TaskDataProvider>(context,listen: false);
    getTodayTasks();
  }

  void getTodayTasks() async {
    await _taskDataProvider.getDatabaseTasks(widget.date);
    setState(() {
      spinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return spinner? Center(child: CircularProgressIndicator()): SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.date}',
                      style: kBlackMediumPlain,
                    ),
                    SizedBox(
                      height: 15,
                    ),
 
                         Container(
                        height: 200,
                        child: _taskDataProvider.tasks.length == 0
                            ? Text('No Task')
                            : TaskListView(
                                snapshot: _taskDataProvider.tasks ,
                              ),
                      ),
                      

                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${_taskDataProvider.tomorrow}',
                      style: kBlackMediumPlain,
                    ),
                         Container(
                        height: 180,
                        child: _taskDataProvider.tasks_tomorrow.length== 0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'No Task',
                                  style: kBlackMediumPlain,
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _taskDataProvider.tasks_tomorrow.length,
                                itemBuilder: (context, index) {
                                  TimeOfDay _time = TimeOfDay(
                                      hour: int.parse(_taskDataProvider.tasks_tomorrow[index]
                                              ['time']
                                          .split(':')[0]),
                                      minute: int.parse(_taskDataProvider.tasks_tomorrow[index]
                                              ['time']
                                          .split(':')[1]));
                                  TimeOfDay _duration = TimeOfDay(
                                      hour: int.parse(_taskDataProvider.tasks_tomorrow[index]
                                              ['duration']
                                          .split(':')[0]),
                                      minute: int.parse(_taskDataProvider.tasks_tomorrow[index]
                                              ['duration']
                                          .split(':')[1]));
                                  DateTime _dateTime =
                                      DateFormat('MMMM d, yyyy', 'en_US')
                                          .parse(_taskDataProvider.tasks_tomorrow[index]["date"])
                                          .add(Duration(
                                              hours: _time.hour,
                                              minutes: _time.minute))
                                          .add(Duration(
                                              hours: _duration.hour,
                                              minutes: _duration.minute));
                                  String task =  _taskDataProvider.tasks_tomorrow[index]['task'].toString();
                                  task = task.length<10? task:task.substring(0,10); 
                                  return Padding(
                                    padding: EdgeInsets.all(6),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: CustomShader(
                                                                            child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.red,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: kBlack, spreadRadius: 5)
                                              ]
                                              // border: Border.all(color: Colors.blue,width: 2)
                                              ),
                                          width: 150,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                               task,
                                                style: kBlackSmallPlain,
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                  '${_time.format(context)} to\n${DateFormat.yMd().add_jm().format(_dateTime)}',textAlign: TextAlign.center,),
                                              MaterialButton(
                                                child: Text('Delete'),
                                                onPressed: () {
                                                   _taskDataProvider.deleteTask(_taskDataProvider.tasks_tomorrow[index]);  
                                              })
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      )
                    
         
                  ],
                ),
              ),
            );
          }
  }
