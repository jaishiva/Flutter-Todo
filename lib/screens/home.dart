import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoo/customWidgets.dart';
import 'package:todoo/model/taskDataProvider.dart';
import 'package:todoo/screens/addTask.dart';
import 'dart:ui' as ui;

import '../constants.dart';
import 'mainpage.dart';
import 'statspage.dart';

class home extends StatefulWidget {
  home({
    Key key,
  }) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  TaskDataProvider _taskDataProvider;

  int _currentIndex = 0;
  bool spinner = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskDataProvider = Provider.of<TaskDataProvider>(context,listen: false);
    syncMarkedDates();
  }
  void syncMarkedDates() async{
    await _taskDataProvider.setMarkedDates();
    print(markedDates);
    setState(() {
      spinner = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return spinner?Center(child: CircularProgressIndicator(),) :Scaffold(
      
    backgroundColor:  _currentIndex==0?backgroundColor: _currentIndex==1?kBrightOrange:kBlack,
    body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top:10.0,left: 10,right: 10),
          child: _currentIndex==0? MainPage():_currentIndex==1?AddNewTask():StatsPage()
        ),
      ),
    bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.add),title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.panorama_fish_eye),title: Text(''))
      ],
      iconSize: 30,
      backgroundColor:  _currentIndex==0?Colors.white: _currentIndex==1?kBrightOrange:kBlack,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      currentIndex: _currentIndex,
      unselectedItemColor: Colors.blue,
      selectedIconTheme: IconThemeData(
        size: 35,
        color: kRed
      ),
      elevation: 5,
      onTap: (value) {setState(() {
        HapticFeedback.mediumImpact();
        _currentIndex = value;
      });} ,
      ),
    );

  }
}


