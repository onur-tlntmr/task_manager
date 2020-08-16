import 'package:task_manager/models/Task.dart';
/*
 * Commandlarin turetildigi abstract sinif
 * Tum commandlarda execute methodunu override
 * etmeyi zaruri kılar.
 */
abstract class ICommand {
  void execute(Task task);
}
