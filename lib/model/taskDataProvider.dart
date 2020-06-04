import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:todoo/constants.dart';

  String selectedDate = DateFormat('MMMM d, yyyy', 'en_US').format(DateTime.now());
List<DateTime> markedDates = [];
class TaskDataProvider extends ChangeNotifier {
  DBProvider db = DBProvider.db;
  List<Map> tasks =[];
  List<Map> tasks_tomorrow = [];
  
  DateTime today;
  String tomorrow;
  Future<void> getDatabaseTasks(date) async {
    tasks = await db.getTasks(date);
    today = DateFormat('MMMM d, yyyy', 'en_US').parse(date);
    tomorrow = DateFormat('MMMM d, yyyy', 'en_US').format(today.add(Duration(days: 1))).toString();
    tasks_tomorrow = await db.getTasks(tomorrow);
    // notifyListeners();
  }

  Future<void> addNewTask(Map<String,dynamic> newTask) async {
    await db.newTask(newTask);
    DateTime _date = DateFormat('MMMM d, yyyy', 'en_US').parse(newTask['date']);
    await setMarkedDates();
    String now = DateFormat('MMMM d, yyyy', 'en_US').format(DateTime.now());
    await getDatabaseTasks(now);
    selectedDate = now;
    notifyListeners();
  }

  Future<void> deleteTask(task) async {
    await db.deleteTask(task['id']);

      await getDatabaseTasks(DateFormat('MMMM d, yyyy', 'en_US').format(today));

    await setMarkedDates();
    notifyListeners();
  }

  Future<void> setMarkedDates() async{
    var unique = await db.getUniquedDates()??[];
    List<DateTime> dates =[];
    await Future.forEach(unique, (e) => dates.add(DateFormat('MMMM d, yyyy', 'en_US').parse((e['date'])))).whenComplete(() { markedDates =  dates?? [];} 
  );
    
    // notifyListeners();
  }
  void changeSelectedDate(date)async{
    selectedDate = DateFormat('MMMM d, yyyy', 'en_US').format(date);
    await getDatabaseTasks(selectedDate);
    notifyListeners();
  }
 
  void setTaskStatus(id,status) async{
    await db.setTaskStatus(id,status);
  }

  Future<bool> getTaskStatus(id) async{
   bool status = await db.getTaskStatus(id).then((value) => value[0]['status']);
  return status;
  }

  void notify(){
    notifyListeners();
  }

  Future<int> getTotalTasks() async{
    List<Map> data = await db.getTotalTasks();
    if(data.length == 0){
      return 0;
    }
    return data[0]['total'];
  }
  Future<int> getCompleteTasks() async{
    List<Map> data = await db.getCompleteTasks();
    if(data.length == 0){
      return 0;
    }
    return data[0]['total'];
  }

}

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    
    return await openDatabase(join(await getDatabasesPath(), 'todoo.db'),
        onCreate: (db, version)  {
       db.execute('''
            CREATE TABLE task (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT,
              task TEXT,
              time TEXT,
              duration TEXT,
              status INTEGER
            )
          ''');
    }, version: 1);
  }

  newTask(newtask) async {
    final db = await database;
    await db.insert('task', newtask);
  }

  Future<List<Map>> getTasks(date) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM task WHERE date = ?
    ''',[date]);
  }

  Future<List<Map>> getUniquedDates() async{
    final db = await database;
    return await db.rawQuery('SELECT DISTINCT date FROM task');
  }

  deleteTask(id) async {
    final db = await database;
    db.rawDelete('''
      DELETE FROM task WHERE id = ? 
    ''', [id]
    );
  }

  deleteTable() async{
    final db = await database;
    db.delete('task');
  }

  Future<void> setTaskStatus(id,status) async{
    final db = await database;
    db.rawUpdate('UPDATE task SET status = ? WHERE id = ?',[status,id]);
  }

  Future<List<Map>> getTaskStatus(id) async{
    final db = await database;
    return await db.rawQuery('SELECT status FROM task WHERE id = ?',[id]);
  }

  Future<List<Map>> getTotalTasks() async{
    final db = await database;
    return await db.rawQuery('SELECT COUNT(*) as total FROM task WHERE true');
  }


  Future<List<Map>> getCompleteTasks() async{
    final db = await database;
    return await db.rawQuery('SELECT COUNT(*) as total FROM task WHERE status = 1');
  }

}
