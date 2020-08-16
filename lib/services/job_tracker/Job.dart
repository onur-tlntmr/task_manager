import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/job_tracker/CommandType.dart';
/*
 * Ozel bir zamanda yapilmasi gereken isleri
 * tutan dataClass'tir.
 * 
 * Ornegin bitis saati gecmis bir Task'i guncelleme isi gibi.
 */
class Job {
  DateTime jobTime; //yapilacak isin zamani
  Task task; //islem yapilacak olan task
  CommandType commandType; //yapilacak olan islemin turu
}
