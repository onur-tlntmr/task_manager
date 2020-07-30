import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';
import 'package:task_manager/ui/widgets/TaskCard.dart';
import 'package:task_manager/utils/Utils.dart';

class DailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return DailyState();
  }
}

class DailyState extends State with Observer {
  final DataSource _dataSource = DataSource();

  final Utils _utils = Utils();

  List<Task> list;

  var current = DateTime.now();

  var w, h;

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    calculateScreenSize(context);

    return Container(
      child:Column(
        children: <Widget>[
          dateWidget(),
          Expanded(
            child: createListView(),
          )
        ],
      ) ,
    );


  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _dataSource.register(this);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        current = current.add(const Duration(seconds: 1));
      });
    });
  }

  void calculateScreenSize(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
  }

  Widget createCard(Task task) {
    return TaskCardWidget(
      task: task,
      onUpdate: () {
        getData();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _dataSource.unregister(this);
  }

  ListView createListView() {

    if(list == null)
      getData();

    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int position) {
          return createCard(list[position]);
        });
  }

  void getData() {
    var taskFuture = _dataSource.getTasks();

    List<Task> dataTask = List();

    taskFuture.then((data) {
      data.forEach((element) {
        dataTask.add(Task.fromObject(element));
      });
    });

    setState(() {
      list = dataTask;
    });
  }

  Widget dateWidget() {
    DateTime dateTime = DateTime.now();

    return Column(
      children: <Widget>[
        Text(_utils.dateFormatter(current),
            style: TextStyle(fontSize: w * 0.04)),
        Text(
          _utils.getLocalDay(dateTime),
          style: TextStyle(fontSize: w * 0.07),
        )
      ],
    );
  }

  @override
  void update() {
    // TODO: implement update
    getData();
  }
}
