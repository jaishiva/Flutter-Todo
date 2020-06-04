import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo/constants.dart';

import 'model/taskDataProvider.dart';
import 'screens/home.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TaskDataProvider(),
    child:   MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: kBlack,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: home(),
    );
  }
}


