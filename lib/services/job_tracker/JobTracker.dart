import 'dart:collection';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/IService.dart';
import 'package:task_manager/services/data_service/DataSource.dart';
import 'package:task_manager/services/data_service/Observer.dart';
import 'package:task_manager/services/job_tracker/CommandInvoker.dart';
import 'package:task_manager/services/job_tracker/CommandType.dart';
import 'package:task_manager/services/job_tracker/ICommand.dart';
import 'package:task_manager/services/time_services/TimeObserver.dart';
import 'package:task_manager/services/time_services/TimeService.dart';
import 'Job.dart';

/*
 * 
 * Bu sinif islerin takibini yapar.
 * Ornek olarak:
 * Bitis zamani gelmis ve tamamlanmamis
 * taskin durumunu guncellemek gibi.
 */
class JobTracker implements TimeObserver, Observer, IService {
  final CommandInvoker _invoker = CommandInvoker();
  final DataSource _dataSource = DataSource();
  final Queue<Job> jobs = Queue();
  final TimeService _timeService = TimeService();
  static final  JobTracker _jobTracker = JobTracker.internal();

  JobTracker.internal();

  factory JobTracker(){
    return _jobTracker;
  }

  void fillJobs() {
    //is kuyrugunu dolduran method

    jobs.clear();

    DateTime now = DateTime.now();
    Future<List> future = _dataSource.getTasksWithDate(now);

    future.then((data) {
      data.forEach((element) {
        Task task = Task.fromObject(element);
        var jobList = createJob(task);

        jobs.addAll(jobList);
      });
    });
  }

  List<Job> createJob(Task task) {
    List<Job> jobList = List();
    DateTime now = DateTime.now();
    print("CreateJobs()");
    if (now.isAfter(task.finishedDate) &&
        !task.isCreateAlarm &&
        task.beginAlarmDuration != null) {
      jobList.add(_createAlarmJob(task));
    }

    if (now.isBefore(task.beginDate) && task.status == "waiting") {
      jobList.add(_createStatusRunning(task));
    }

    if (now.isBefore(task.finishedDate) && //eger task bitmemis ise ve
        task.status == "running") {
      //bekliyor veya devam ediyor durumunda ise

      jobList.add(_createStatusIncomplete(task));
    }

    return jobList;
  }

  Job _createAlarmJob(Task task) {
    Job job = Job();

    DateTime now = DateTime.now();

    job.commandType = CommandType.alarmCreate;

    job.jobTime = now;

    job.task = task;

    return job;
  }

  Job _createStatusIncomplete(Task task) {
    Job job = Job();

    job.commandType = CommandType.statusIncomplete;

    job.jobTime = task.finishedDate;

    job.task = task;

    return job;
  }

  Job _createStatusRunning(Task task) {
    Job job = Job();

    job.commandType = CommandType.statusRunning;

    job.jobTime = task.beginDate;

    job.task = task;

    return job;
  }

  @override
  void timeChanged(DateTime newTime) {
    if (jobs.length != 0) {
      Job firstJob = jobs.first;

      int result = newTime.compareTo(firstJob.jobTime);

      if (result >= 0) {
        ICommand command = _invoker.invoke(firstJob.commandType);
        command.execute(firstJob.task);
        jobs.removeFirst();
      }
      print("Jobs Lenght: ${jobs.length}");
    }
  }

  @override
  void update() {
    fillJobs();
  }

  @override
  void closeService() {
    _dataSource.unregister(this);
    _timeService.unregister(this);
  }

  @override
  void startService() {
    _dataSource.register(this);
    _timeService.register(this);
    fillJobs();
  }
}
