import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/job_tracker/ICommand.dart';
import 'package:task_manager/services/job_tracker/Reciver.dart';

class StatusRunningCommand implements ICommand {
  Reciver reciver = Reciver();

  @override
  void execute(Task task) {
    reciver.statusRuningUpdate(task);
  }
}
