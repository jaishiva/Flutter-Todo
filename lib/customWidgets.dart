import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoo/model/taskDataProvider.dart';

import 'constants.dart';

class CustomRect extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    RRect rect =
        RRect.fromLTRBR(0.0, 0.0, size.width, 200, Radius.circular(25));
    return rect;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class CustomShader extends StatelessWidget {
  final Widget child;
  CustomShader({this.child});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            colors: [Colors.teal, Colors.blue],
            tileMode: TileMode.mirror,
          ).createShader(rect);
        },
        blendMode: BlendMode.color,
        child: child);
  }
}

class TaskListView extends StatefulWidget {
  dynamic snapshot;
  final Axis axis;
  final double height;
  final double width;
  TaskListView({
    @required this.snapshot,
    this.axis,
    this.height,
    this.width,
    Key key,
  }) : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> with TickerProviderStateMixin{
TaskDataProvider _taskDataProvider;
// AnimationController _animationController;
List<bool> isSelected = [true];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    _taskDataProvider = Provider.of<TaskDataProvider>(context);
    return ListView.builder(
    scrollDirection: widget.axis??Axis.vertical,
    itemCount: widget.snapshot.length,
    itemBuilder: (context, index) {
      TimeOfDay _time = TimeOfDay(hour: int.parse(widget.snapshot[index]['time'].split(':')[0]), minute: int.parse(widget.snapshot[index]['time'].split(':')[1]));
      TimeOfDay _duration = TimeOfDay(hour: int.parse(widget.snapshot[index]['duration'].split(':')[0]), minute: int.parse(widget.snapshot[index]['duration'].split(':')[1]));
      DateTime _dateTime = DateFormat('MMMM d, yyyy', 'en_US').parse(widget.snapshot[index]["date"]).add(Duration(hours: _time.hour,minutes: _time.minute)).add(Duration(hours: _duration.hour,minutes: _duration.minute));
      String task =  widget.snapshot[index]['task'].toString().length > 12?  widget.snapshot[index]['task'].toString().substring(0,12): widget.snapshot[index]['task'];
      int id = widget.snapshot[index]['id'];
      bool status = widget.snapshot[index]['status']==1?true:false;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
                  child: CustomShader(
                    child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kOrange//Colors.red,
                //  border: Border.all(color: Colors.blue,width: 2)
              ),
              constraints: BoxConstraints(
                maxHeight: 100,
                minHeight: widget.height??80
              ),
              width: widget.width??150,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children :  [CircleAvatar(child: Icon(Icons.today,size: 25,)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         task ,
                          style: kBlackSmallPlain,
                          textAlign: TextAlign.left,
                        ),
                     Text(
                      '${_time.format(context)} to\n${DateFormat.yMd().add_jm().format(_dateTime)}'
                    ),
                      ],
                    ),
                    

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // SizedBox(height: 10,),
                            Checkbox(value: status, onChanged: 
                              (value) async{
                              
                                  _taskDataProvider.setTaskStatus(id, value?1:0);
                                 await _taskDataProvider.getDatabaseTasks(widget.snapshot[index]["date"]);
                                  widget.snapshot = _taskDataProvider.tasks;
                                  setState(() {
                                   
                                  });
                                  
  
                              },
                            ),
                          MaterialButton(
                              padding: EdgeInsets.all(1),
                              child: Text('Delete'),
                              onPressed: () {
                               _taskDataProvider.deleteTask(_taskDataProvider.tasks[index]);  
                            }),
                        ],
                      )],
                  ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
