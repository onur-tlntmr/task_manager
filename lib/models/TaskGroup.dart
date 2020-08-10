import 'Task.dart';

/*
*TaskGroupWidget icin viewModel
* İcerisinde title ve tasklarin buludu collection yer alir
*
* */

class TaskGroup {
  List<Task> taskList;

  String title;

  TaskGroup() {
    taskList = List();
  }

  TaskGroup.withTitle(this.title) {
    TaskGroup();
  }
}
