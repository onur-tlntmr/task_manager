import 'package:task_manager/services/job_tracker/CommandType.dart';
import 'package:task_manager/services/job_tracker/ICommand.dart';
import 'package:task_manager/services/job_tracker/StatusCommand.dart';

/*
 * Bu sinif command'lara erisimi saglar.
 * 
 * 
 */

class CommandInvoker {
  Map<CommandType, ICommand> commands; //Commandlarin tutuldugu yapi

  CommandInvoker() {
    commands = Map(); 

    commands.putIfAbsent(CommandType.status, () => StatusCommand()); //Status command ekleniyor
  }

  ICommand invoke(CommandType commandType) { //istenilen commandType'ine gore 
    return commands[commandType]; //Command geri donderir
  }
}
