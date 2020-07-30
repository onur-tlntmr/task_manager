import 'dart:async';
import 'package:intl/intl.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';

class DataUpdaterService {
  Timer _timer;

  final DataSource _dataSource = DataSource();

  List<Task> taskList = List();

  static final DataUpdaterService _updaterService =
      DataUpdaterService._interal();

  DataUpdaterService._interal();

  factory DataUpdaterService() {
    return _updaterService;
  }

  void getList() {
    _dataSource.getTasks().then((value) {
      value.forEach((element) {
        taskList.add(Task.fromObject(element));
      });
    });
  }

  void startService() {
    _startTimer();
  }

  void closeService() {
    _timer.cancel();
  }

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      getList();

      DateTime current = DateTime.now();


      taskList.forEach((element) {
//        print("Current: $current BeginDate: ${element.finishedDate}");
        if (current.isAfter(element.finishedDate) &&
            element.status == "waiting") {
          element.status = "incomplete";

          print("Current: $current BeginDate: ${element.finishedDate}");

          _dataSource.update(element);

          print("Yakalandi: ${element.title}");
        }
      });
      taskList.clear();
    });
  }
}
