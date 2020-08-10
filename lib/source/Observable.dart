
import 'Observer.dart';

/*Kaynagi olan classlarin gozlemlenebilir kabileyet kazandirmasini saglayan
* abstract siniftir*/
abstract class Observable {

  void register(Observer o);

  void unregister(Observer o);

  void notifyObservers();

}