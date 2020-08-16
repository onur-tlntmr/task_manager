import 'dart:collection';
import 'package:task_manager/services/job_tracker/CommandInvoker.dart';
import 'Job.dart';

/*
 * 
 * Bu sinif islerin takibini yapar.
 * Ornek olarak:
 * Bitis zamani gelmis ve tamamlanmamis
 * taskin durumunu guncellemek gibi.
 */
class JobTracker {
  CommandInvoker _invoker;

  Queue<Job> jobs;

  JobTracker() { //initalize variables.
    _invoker = CommandInvoker();
    jobs = Queue();
  }

  void fillJobs(){
    //TODO implement method
  }


}
