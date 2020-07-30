import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/models/TaskGroup.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';
import 'package:task_manager/ui/widgets/TaskGroupWidget.dart';
import 'package:task_manager/utils/Utils.dart';

class MonthlyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MonthlyState();
  }
}

class MonthlyState extends State<MonthlyPage> with Observer {

  final DataSource _dataSource = DataSource();
  final Utils _utils = Utils();

  Map<int, TaskGroup> _listGroup;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: createListView(),
    );
  }

  @override
  void initState() {
    super.initState();
    _dataSource.register(this);
  }

  @override
  void dispose() {
    super.dispose();
    _dataSource.unregister(this);
  }

  @override
  void update() {
    // TODO: implement update

    getListGroups();
  }

  void getListGroups() {
    Map<int, TaskGroup> list = Map();

    var taskFuture = _dataSource.getTasks();



      taskFuture.then((data){ //db'den future olarak veriler alindi

        data.forEach((element) { // tum veriler gezildi
          Task task = Task.fromObject(element); //alinan veri task obj donusturuldu

          int day = task.beginDate.day; // gun alindi



          if(!list.containsKey(day)) { // daha once gun yoksa collection'da olusturuldu

            TaskGroup taskGroup = TaskGroup();
            taskGroup.title = DateFormat.MMMd("tr_TR").format(task.beginDate);

            list.putIfAbsent(day, () => taskGroup);
          }
            list[day].taskList.add(task); //kendi grubuna eklendi

          print("$task");

        });


      });

    setState(() {
      _listGroup = list;
    });
  }

  TaskGroupWidget createTaskGroupWidget(TaskGroup taskGroup) {
    return TaskGroupWidget(
      taskGroup: taskGroup,
      onUpdate: () {
        update();
      },
    );
  }

  ListView createListView() {
    if (_listGroup == null) getListGroups();

    return ListView.builder(
        itemCount: _listGroup.length,
        itemBuilder: (BuildContext context, int position) {

          //map'a index uzerinden erisebilmek icin anahtarlari listeye donusturuyoruz
          List keys = _listGroup.keys.toList();

          return createTaskGroupWidget(_listGroup[keys[position]]);
        });
  }
}
