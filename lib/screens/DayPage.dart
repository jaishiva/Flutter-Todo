import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoo/customWidgets.dart';
import 'package:todoo/constants.dart';
import 'package:todoo/model/taskDataProvider.dart';

class DayPage extends StatefulWidget {
  String date;

  DayPage({Key key, @required this.date}) : super(key: key);

  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  TaskDataProvider _taskDataProvider;
  bool spinner = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskDataProvider = Provider.of<TaskDataProvider>(context, listen: false);
    getTodayTasks();
  }

  void getTodayTasks() async {
    String _date =
        DateFormat('MMMM d, yyyy', 'en_US').format(DateTime.now()).toString();
    await _taskDataProvider.getDatabaseTasks(widget.date);
    if(mounted){
 setState(() {
        spinner = false;
    });
  }
    }
   

  @override
  Widget build(BuildContext context) {
    return spinner
        ? Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.black,
          ))
        : Column(
            children: [
              Text('${widget.date}'),
              Container(
                  height: 300,
                  child: Consumer<TaskDataProvider>(
                    builder: (context, value, child) =>
                        value.tasks.length == 0
                            ? Center(child: Text('No Task'))
                            : TaskListView(snapshot: value.tasks),
                  ))
            ],
          );
  }
}
