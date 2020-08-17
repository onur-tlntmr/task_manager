import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/job_tracker/ICommand.dart';
import 'package:task_manager/services/job_tracker/Reciver.dart';

class AlarmCreateComand implements ICommand {
  Reciver reciver = Reciver();

  @override
  void execute(Task task) {
    reciver.createAlarm(task);
  }
}
