import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/utils/Utils.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }


}

class AddPageState extends State {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //snackbar icin gerekli
  TextEditingController _txtController = TextEditingController(); //texfield'daki degeri almak icin gerekli

  final DataSource _dataSource = DataSource();

  Utils _utils = Utils();

  bool isSave = false; //kayit islemi yapilip yapilmadigini gosteren method

  //Task zamanlarini tuttan degiskenler
  DateTime _finisDate;
  DateTime _beginDate;

  //Slider'daki degerler
  double _hourValue = 0;
  double _minuteValue = 0;



  @override
  Widget build(BuildContext context) {

    //ekran boyutlarina gore yuzdesel deger vermek icin gerekli
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;


    final double _rowSpace = height * 0.06; //Her satir arasında cozunurlugun %6'si kadar bosluk birakir

    return  Scaffold(
          //klavye acilinca ekran tasmamasi icin gerekli
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: Container(
              margin: EdgeInsets.symmetric(
                  vertical: height * 0.1, horizontal: 0.05 * width),//%10 alt ve ustten %5 sag ve soldan bosluk
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      autofocus: false,
                      controller: _txtController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: "Başlık",
                      ),
                    ),
                  ),
                  SizedBox(height: _rowSpace),
                  //aralarina bosluk olusturmak icin kullanilir
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
//                        elevation: 4.0,
                        child:
                            Text("Tarih Seç", style: TextStyle(fontSize: width*0.05)),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              minTime: DateTime.now(), // gecmisi secmesini engeller
                              maxTime: DateTime.now().add(new Duration(days: 30)), // 30 gun sonrasini secmesini engeller
                              onConfirm: (date) {
                            setState(() {
                              _beginDate =
                                  date; //yeni baslangic degerini gunceler
                              calculateFinishDate(); //bitistarihi yeniden hesaplanir
                            });
                          }, locale: LocaleType.tr);
                        },
                      ),
                      Container(
                          //Secilen tarih
                          margin: EdgeInsets.only(left: width * 0.05),
                          child: Text(
                            "Seçilen Tarih: ${_utils.dateFormatter(_beginDate)}",
                            style: TextStyle(
                              fontSize: width *0.04,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(height: _rowSpace),
                  Text(
                    "İşlem Süresi: ",
                    style: TextStyle(fontSize: 0.08),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: width * 0.08),
                        child: Text(
                          "Saat:",
                          style: TextStyle(fontSize: width*0.05),
                        ),
                      ),
                      Container(
                        width: width * 0.68,
                        child: SliderTheme(
                          data: getSliderData(),
                          child: Slider(
                            value: _hourValue,
                            min: 0,
                            max: 12,
                            divisions: 10,
                            label: '${_hourValue.toInt()}',
                            //Slider daki deger int olarak suruklenirken gosterilir
                            onChanged: (value) {
                              setState(
                                () {
                                  _hourValue = value; // saat degeri guncellenir
                                  calculateFinishDate(); // bitis tarihi tekrar hesaplanir
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Dakika:",
                        style: TextStyle(fontSize: width*0.05),
                      ),
                      Container(
                        width: width * 0.68,
                        child: SliderTheme(
                          data: getSliderData(),
                          child: Slider(
                            value: _minuteValue,
                            min: 0,
                            max: 60,
                            divisions: 60,
                            label: '${_minuteValue.toInt()}',
                            onChanged: (value) {
                              setState(
                                () {
                                  _minuteValue = value;
                                  calculateFinishDate();
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: _rowSpace),
                  Text("Bitiş Tarihi: ${_utils.dateFormatter(_finisDate)}",
                      //Bitis tarihini ekrana basar
                      style: TextStyle(fontSize: width*0.06)),
                  SizedBox(height: _rowSpace),
                  RaisedButton(
                    child: Text(
                      "Kaydet",
                      style: TextStyle(fontSize: width*0.05),
                    ),
                    onPressed: () {
                      if (!resultIsValidate()) {// Eger girilen degerler gecerli degilse mesaj gosteriliyor

                        final snackBar = SnackBar(
                            content: Text('Eksik veya yanlış veri girdiniz !'));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }

                      else {

                        insertTask(createTask());

                      }

                    },
                  )
                ],
              ),
            ));
  }
  @override
  void dispose() { //ui dispose edildiginde controller nesnesi de dispose ediliyor
    super.dispose();

    _txtController.dispose();
  }

  Task createTask(){ //Ui'da girilen verilerden task nesnesi olusturan method

    Task task = new Task();

    task.title = _txtController.text;
    task.beginDate = _beginDate;
    task.finishedDate = _finisDate;
    task.status = "waiting";

    return task;

  }
  void calculateFinishDate() {
    //bitis tarihini hesaplayan method
    if (_beginDate != null) {
      // tarih bos degilse baslangic tarihine esitler
      _finisDate = _beginDate;

      Duration duration = new Duration(
        // girilen saat ve tarih eklenir
          hours: _hourValue.toInt(),
          minutes: _minuteValue.toInt());

      _finisDate = _finisDate.add(duration);
    }
  }



  getSliderData() {
    //Sliderlarda datalarin gorunmesi saglayan method
    return SliderTheme.of(context).copyWith(
      activeTrackColor: Colors.red[700],
      inactiveTrackColor: Colors.red[100],
      trackShape: RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
      thumbColor: Colors.redAccent,
      overlayColor: Colors.red.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      activeTickMarkColor: Colors.red[700],
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: Colors.redAccent,
      valueIndicatorTextStyle: TextStyle(
        color: Colors.white,
      ),
    );
  }

  bool resultIsValidate() {
    //gecerli bir bitis tarihinin olup olmadigini kontrol eden method
    if (_finisDate != null &&
        (_hourValue != 0 || _minuteValue != 0) &&
        _txtController.text.trim().isNotEmpty) return true;

    return false;
  }



  void insertTask(Task task) async{ // DB'ye task ekliyen method

    var result = await _dataSource.insert(task); //datayi ekler

    if(result != 1) { // eger bir hata olusmadiysa
      isSave = true; //kayit bayragi kaldirilir
    }
  }

}
