import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo/model/taskDataProvider.dart';

import '../constants.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool spinner = true;
  int total_tasks;
  int complete_tasks;
  TaskDataProvider _taskDataProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskDataProvider = Provider.of<TaskDataProvider>(context,listen: false);
    LoadData();
  }

  void LoadData() async{
   total_tasks =  await _taskDataProvider.getTotalTasks();
   complete_tasks =  await _taskDataProvider.getCompleteTasks();
    setState(() {
      spinner = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: spinner? CircularProgressIndicator() :Column(
        children: [
          Text('Data Report',style: kBlackMediumPlain,),

        ],
      ),
    );
  }
}