import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/data_service/DataSource.dart';

/*
 * Command sinfilarinin
 * action'larini tutan siniftir.
 * 
 */
class Reciver {
  final DataSource _dataSource = DataSource();

  void statusIncompleteUpdate(Task task) {
    task.status = "incomplete";

    _dataSource.update(task); //update'i veri tabanina yansit
  }

  void statusRuningUpdate(Task task) {
    task.status = "running";

    _dataSource.update(task); //update'i veri tabanina yansit
  }

  void createAlarm(Task task) {}
}
