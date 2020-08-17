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

  //is kuyrugunu dolduran method
  void fillJobs() {
    
    jobs.clear(); 

    DateTime now = DateTime.now();
    //Bu gunun tasklari aliniyor.
    Future<List> future = _dataSource.getTasksWithDate(now); 

    future.then((data) { //Her taskin joblist'i olusturuluyor
      data.forEach((element) {
        Task task = Task.fromObject(element);
        var jobList = createJob(task);

        jobs.addAll(jobList); //ve collection'a ekleniyor
      });
    });
  }

  //Tasklardan job olusturan method
  //Bir taskin birden fazla job'i olacabiligi icin
  //Job listesi donderir
  List<Job> createJob(Task task) { 

    List<Job> jobList = List();
    DateTime now = DateTime.now();

    if (now.isBefore(task.beginDate) && //Eger task baslamamis ise
        !task.isCreateAlarm && //Alarimi olsturulmamis
        task.beginAlarmDuration != null) { //alarimi bos degilse
      jobList.add(_createAlarmJob(task)); //Alarim olstur
    }

    if (now.isBefore(task.beginDate) && task.status == "waiting") { //eger task baslamis ise
      jobList.add(_createStatusRunning(task)); //running job olustur
    }

    if (now.isBefore(task.finishedDate) && //eger task bitmis ise ve
        task.status == "running") {
      //ve devam ediyor konumundaysa

      jobList.add(_createStatusIncomplete(task)); //tamamlanmadi job olustur
    }

    return jobList; 
  }

/////////////////////// job olusturnan methodlar///////////////////////
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
  ////////////////////////////////////////////////////////////

  //Zaman guncellendikce yapilacak olan en yakin isi takib eder
  //Eger varsa isi yapar ve isi kuyruktan cikarir
  @override
  void timeChanged(DateTime newTime) { 
    if (jobs.length != 0) { 
      Job firstJob = jobs.first;

      int result = newTime.compareTo(firstJob.jobTime); //yeni zaman ile isi
                          //karsilastirir eger ayni ise 1, gemis ise -1 doner

      if (result >= 0) { 
        ICommand command = _invoker.invoke(firstJob.commandType); //isi yapan komudu getir
        command.execute(firstJob.task); //isi icra et
        jobs.removeFirst(); //ve isi kuyruktan cikar
      }
    }
  }

  @override
  void update() { //Verilerde bir guncelleme olunca kendini de gunceller
    fillJobs();
  }

  //bagli oldugu servisleri kapatarak kendini etkisiz hale getirir
  @override
  void closeService() { 
    _dataSource.unregister(this);
    _timeService.unregister(this);
  }
  //kendini servislere ekleyerek tekrar gorevini icra eder
  @override
  void startService() {
    _dataSource.register(this);
    _timeService.register(this);
    fillJobs();
  }
}
