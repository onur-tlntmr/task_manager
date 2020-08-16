import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/job_tracker/ICommand.dart';
import 'package:task_manager/services/job_tracker/Reciver.dart';
/*
 * 
 * Tasklarin statusunu guncelleyen command
 * 
 * 
 */
class StatusCommand implements ICommand {

  final Reciver reciver = Reciver(); //Operasyonu kullanmak icin gerekli

  @override
  void execute(Task task) {
    reciver.statusUpdate(task); //yapilan is reciver'daki methoda delege edilir
  }
}
