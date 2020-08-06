import 'Task.dart';

/*
*TaskGroupWidget icin viewModel
* İcerisinde title ve tasklarin buludu collection yer alir
*
* */

class TaskGroup{
  List<Task> _taskList;

  String _title;


  TaskGroup(){
    _taskList = List();
  }


  TaskGroup.withTitle(this._title){
    TaskGroup();
  }


  List<Task> get taskList => _taskList;

  set taskList(List<Task> value) {
    _taskList = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }




}