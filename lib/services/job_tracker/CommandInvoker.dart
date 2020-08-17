import 'package:task_manager/services/job_tracker/AlarmCreateCommand.dart';
import 'package:task_manager/services/job_tracker/CommandType.dart';
import 'package:task_manager/services/job_tracker/ICommand.dart';
import 'package:task_manager/services/job_tracker/StatusIncompleteCommand.dart';
import 'package:task_manager/services/job_tracker/StatusRunningCommand.dart';

/*
 * Bu sinif command'lara erisimi saglar.
 * 
 * 
 */

class CommandInvoker {
  Map<CommandType, ICommand> commands; //Commandlarin tutuldugu yapi

  CommandInvoker() {
    commands = Map(); 

    commands.putIfAbsent(CommandType.statusIncomplete, () => StatusIncompleteCommand()); //Status command ekleniyor
    commands.putIfAbsent(CommandType.statusRunning, () => StatusRunningCommand()); //Status command ekleniyor
    commands.putIfAbsent(CommandType.alarmCreate, () => AlarmCreateComand()); //Status command ekleniyor

  }

  ICommand invoke(CommandType commandType) { //istenilen commandType'ine gore 
    return commands[commandType]; //Command geri donderir
  }
}
