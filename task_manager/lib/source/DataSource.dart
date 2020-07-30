import 'package:task_manager/db/DbHelper.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/Observable.dart';
import 'package:task_manager/source/Observer.dart';

class DataSource extends Observable{

  static List<Observer> list;
  static DataSource _dataSource = DataSource._interial();
  final DbHelper _dbHelper=DbHelper();

  DataSource._interial(){
    list = List();
  }

  factory DataSource(){
    return _dataSource;
  }

  @override
  void notifyObservers() {
    list.forEach((element) {element.update();});
  }

  @override
  void register(Observer o) {

    list.add(o);

  }

  @override
  void unregister(Observer o) {

    list.remove(o);

  }


  Future<List> getTasks() async{
    var list = await _dbHelper.getTasks();
    return list;
  }

  Future<int> insert(Task task) async{
    var result = await _dbHelper.insert(task);
    notifyObservers();
    return result;
  }

  Future<int> update(Task task) async{
    var result = await _dbHelper.update(task);


    notifyObservers();
    return result;
  }

  Future<int> delete(Task task) async{
    var result = await _dbHelper.delete(task.id);
    notifyObservers();
    return result;
  }


}