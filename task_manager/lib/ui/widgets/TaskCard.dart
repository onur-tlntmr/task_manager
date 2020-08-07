import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/utils/DateUtils.dart';

//TaskCarWidget tasklari gosterir

class TaskCardWidget extends StatefulWidget {

  final Task task; //Task nesnesi

  final Function onUpdate; //Herhangi bir evente tetiklenecek method

  const TaskCardWidget({@required this.task, this.onUpdate});

  @override
  _TaskCardState createState() => _TaskCardState();

}

class _TaskCardState extends State<TaskCardWidget> {

  Map<String, IconData> iconMap = { //Duruma gore secilecek iconllar
    'waiting': Icons.access_time,
    'incomplete': Icons.cancel,
    'complete': Icons.check,
    'running': Icons.play_circle_outline
  };

  final DateUtils _utils = DateUtils(); //Saat tarih icin gerekli
  final DataSource _dataSource = DataSource(); //Eventler icin gerekli


  @override
  Widget build(BuildContext context) {
    //Ust siniftaki variable'lar aliniyor
    Task task = widget.task;

    var _beginDate = _utils.dateFormatter(task.beginDate);
    var _finishedDate = _utils.dateFormatter(task.finishedDate);


    return Card(

      child: ListTile(
        leading: IconButton(icon: Icon(iconMap[task.status])),
        title: Text(widget.task.title),
        subtitle: Text("$_beginDate\n$_finishedDate"),

        onTap: () {
          checkedTask(task);
        },

        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteTask(task);
          },
        ),

      ),

    );
  }

  void deleteTask(Task task) async {
    await _dataSource.delete(task);
    widget.onUpdate();
  }

  void checkedTask(Task task) {
    DateTime current = DateTime.now();

    if (task.status == "waiting" || task.status ==
        "running") { // Islem bekleyen veya devam eden durumda ise
      task.status = "complete";
      _dataSource.update(task);
      widget.onUpdate();
    }

    else if (task.finishedDate.isAfter(current)) { //Eger task bitmemis ise

      if (task.beginDate.isAfter(current))
        task.status = "waiting";
      else
        task.status = "running";

      _dataSource.update(task);
      widget.onUpdate();
    }
  }
}