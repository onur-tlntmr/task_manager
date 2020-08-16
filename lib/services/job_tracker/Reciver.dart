import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';

/*
 * Command sinfilarinin
 * action'larini tutan siniftir.
 * 
 */
class Reciver {
  final DataSource _dataSource = DataSource();

  void statusUpdate(Task task) {
    if (task.status == "waiting" || task.status == "running") {
      //bekliyor veya devam ediyor durumunda ise
      task.status = "incomplete"; //tamamlanmamis olarak guncelle

      _dataSource.update(task); //update'i veri tabanina yansit
    }
  }
}
