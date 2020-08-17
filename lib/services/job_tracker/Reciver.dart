import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/data_service/DataSource.dart';

/*
 * Command sinfilarinin
 * action'larini tutan siniftir.
 * 
 */
class Reciver {
  final DataSource _dataSource = DataSource();

  //Task durumunu tamamlanmadi olarak gunceller
  void statusIncompleteUpdate(Task task) { 
    task.status = "incomplete";

    _dataSource.update(task); //update'i veri tabanina yansit
  }

  //Task durmunu devam ediyor olrak gunceller
  void statusRuningUpdate(Task task) {
    task.status = "running";

    _dataSource.update(task); //update'i veri tabanina yansit
  }

  void createAlarm(Task task) {
    //TODO implement method
  }
}
