import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/job_tracker/ICommand.dart';
import 'package:task_manager/services/job_tracker/Reciver.dart';
/*
 * 
 * Tasklarin statusunu guncelleyen command
 * 
 * 
 */
class StatusIncompleteCommand implements ICommand {

  final Reciver reciver = Reciver(); //Operasyonu kullanmak icin gerekli

  @override
  void execute(Task task) {
    reciver.statusIncompleteUpdate(task); //yapilan is reciver'daki methoda delege edilir
  }
}
