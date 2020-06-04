import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo/model/taskDataProvider.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
  Size size;
  double complete_percent;
  double inComplete_percent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskDataProvider = Provider.of<TaskDataProvider>(context, listen: false);

    LoadData();
  }

  void LoadData() async {
    total_tasks = await _taskDataProvider.getTotalTasks();
    complete_tasks = await _taskDataProvider.getCompleteTasks();
    complete_percent = total_tasks == 0?0:(complete_tasks/total_tasks);
    inComplete_percent = total_tasks == 0?0:(1-complete_percent);
    setState(() {
      spinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: spinner
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                  ),
                  Text(
                    'Data Report',
                    style: kBlackMediumPlain,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: size.width / 2,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(blurRadius: 7, color: kBlack)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(child: Image.asset('assets/pie-chart.png')),
                        SizedBox(
                          height: 20,
                        ),
                        Text.rich(TextSpan(
                            text: '$total_tasks',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                            children: [
                              TextSpan(
                                  text: ' Total Tasks', style: kBlackSmallPlain)
                            ])),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                                              child: Container(
                          padding: EdgeInsets.all(10),
                          // width: size.width/2,
                          height: 230,
                          decoration: BoxDecoration(
                              color: kRed,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                               BoxShadow(blurRadius: 7, color: kBlack)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Complete',style: TextStyle(
                                fontSize: 24,
                                color: Colors.white
                              ),),
                              SizedBox(height: 20,),
                              CircularPercentIndicator(
                                radius: 130,
                                startAngle: 0.0,
                                animation: true,
                                animationDuration: 500,
                                percent: complete_percent,
                                // lineWidth: 10,
                                backgroundColor: Colors.white38,
                                progressColor: Colors.white,
                                center: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: '${(complete_percent*100).toInt()}',
                                          style: TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '%',
                                              style: TextStyle(color: Colors.white,fontSize: 12)
                                            )
                                          ]
                                        )
                                      ),
                                      Text('$complete_tasks/$total_tasks',style: TextStyle(color: Colors.white,fontSize: 18),)
                                    ],
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                        Flexible(
                                                  child: Container(
                          padding: EdgeInsets.all(10),
                          // width: size.width/2,
                          height: 230,
                          decoration: BoxDecoration(
                              color: kDarkBlue,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                               BoxShadow(blurRadius: 7, color: kBlack)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Incomplete',style: TextStyle(
                                fontSize: 24,
                                color: Colors.white
                              ),),
                              SizedBox(height: 20,),
                              CircularPercentIndicator(
                                radius: 130,
                                startAngle: 0.0,
                                animation: true,
                                animationDuration: 500,
                                percent: complete_percent,
                                // lineWidth: 10,
                                backgroundColor: Colors.white38,
                                progressColor: Colors.white,
                                center: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: '${(inComplete_percent*100).toInt()}',
                                          style: TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '%',
                                              style: TextStyle(color: Colors.white,fontSize: 12)
                                            )
                                          ]
                                        )
                                      ),
                                      Text('${total_tasks- complete_tasks}/$total_tasks',style: TextStyle(color: Colors.white,fontSize: 18),)
                                    ],
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                      ),
                        ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
