import 'TimeObserver.dart';

abstract class TimeObservable {
  void register(TimeObserver observer);
  void unregister(TimeObserver observer);
  void notfiyAll();
}
