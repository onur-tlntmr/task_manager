
import 'Observer.dart';

abstract class Observable {

  void register(Observer o);

  void unregister(Observer o);

  void notifyObservers();

}