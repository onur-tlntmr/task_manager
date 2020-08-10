import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/utils/DateUtils.dart';

/*
* Gorevi task ekler ve eklendikten sonra observer
* siniflari uyarir
*
* */

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }
}

class AddPageState extends State {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); //snackbar icin gerekli

  TextEditingController _txtController =
      TextEditingController(); //texfield'daki degeri almak icin gerekli

  final DataSource _dataSource = DataSource();

  DateUtils _utils = DateUtils(); //Tarih donusumlerinde kullanilir

  bool isSave = false; //kayit islemi yapilip yapilmadigini gosteren method

  //Task zamanlarini tuttan degiskenler
  DateTime _finisDate;
  DateTime _beginDate;

  //Slider'daki degerler
  double _hourValue = 0;
  double _minuteValue = 0;

  //Ekran boyutlarini saklar
  var height;
  var width;

  double _rowSpace; //Satir arasi bosluklar

  @override
  Widget build(BuildContext context) {
    initializeVariable(context); //Degiskenlere degerleri atar

    return createScaffold(); //Sayfadaki ana widget
  }

  Widget createScaffold() {
    //Sayfaya anaWidget'i donderir
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        //klavye acilinca ekran tasmamasi icin gerekli

        key: _scaffoldKey,
        //

        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: height * 0.1, horizontal: 0.05 * width),
          //%10 alt ve ustten %5 sag ve soldan bosluk

          child: Column(
            children: <Widget>[
              createTitleInput(), //Task basligini alir

              //aralarina bosluk olusturmak icin kullanilir
              SizedBox(height: _rowSpace),

              createDateSelector(), //Baslangic zamanini secer

              SizedBox(height: _rowSpace),

              createHourSelector(), //Saat secim slider'i

              SizedBox(height: _rowSpace),

              createMinuteSelector(), //Dakika secim slider'i

              SizedBox(height: _rowSpace),

              createFinishTxt(), //Bitis tarihi

              createSaveButton() //Kaydet butonu
            ],
          ),
        ));
  }

  void initializeVariable(BuildContext context) {
    //ekran boyutlarina gore yuzdesel deger vermek icin gerekli
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    _rowSpace = height * 0.06; //her satir arasina %6'lik bir bosluk ekler
  }

  Widget createTitleInput() {
    //Basligi alan widget
    return Container(
      child: TextField(
        autofocus: false, //direkt olarak secili olmamasi icin
        controller: _txtController,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: "Başlık",
        ),
      ),
    );
  }

  Widget createDateSelector() {
    //Baslangic zamanini secimini yapan widget
    return Row(
      children: <Widget>[
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//           Butonun koslerini yuvarlar

          child: Text("Tarih Seç", style: TextStyle(fontSize: width * 0.05)),

          onPressed: () {
            DatePicker.showDateTimePicker(context,
                minTime: DateTime.now(),
                // gecmisi secmesini engeller
                maxTime: DateTime.now().add(new Duration(days: 30)),
                // 30 gun sonrasini secmesini engeller
                onConfirm: (date) {
              setState(() {
                _beginDate = date; //yeni baslangic degerini gunceler
                calculateFinishDate(); //bitistarihi yeniden hesaplanir
              });
            }, locale: LocaleType.tr); //Yerellestirme yapiliyor
          },
        ),
        Container(
            //Secilen tarihi ekranda gostirir
            margin: EdgeInsets.only(left: width * 0.05),
            child: Text(
              "Seçilen Tarih: ${_utils.dateFormatter(_beginDate)}",
              style: TextStyle(
                fontSize: width * 0.04,
              ),
            ))
      ],
    );
  }

  Widget createHourSelector() { //Saat Secimi icin  slider widget'i
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: width * 0.08),
          child: Text(
            "Saat:",
            style: TextStyle(fontSize: width * 0.05),
          ),
        ),
        Container(
          width: width * 0.68,
          child: SliderTheme( //Slider'i custom tema icin gerekli
            data: getSliderData(),
            child: Slider(
              value: _hourValue, // sayiyi deger olarak secer
              min: 0,
              max: 12,
              divisions: 12, //Slideri 12'ye boler
              label: '${_hourValue.toInt()}', //Secilen degeri gosterir
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
    );
  }

  Widget createMinuteSelector() { //Dakika secimi yapan wiget
    return Row(
      children: <Widget>[
        Text(  //Slider adi
          "Dakika:",
          style: TextStyle(fontSize: width * 0.05),
        ),
        Container(
          width: width * 0.68,
          child: SliderTheme( //Slider'i custom tema icin gerekli
            data: getSliderData(),
            child: Slider(
              value: _minuteValue,// dakikayi deger olarak secer
              min: 0,
              max: 60,
              divisions: 60,//Slider'i 60'a boler
              label: '${_minuteValue.toInt()}', //Secilen degeri gosterir
              onChanged: (value) {
                setState(
                  () {
                    _minuteValue = value; //dakika degerini gunceller
                    calculateFinishDate(); //bitis tarihi tekrardan hesaplar
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget createFinishTxt() {
    return Text("Bitiş Tarihi: ${_utils.dateFormatter(_finisDate)}",//Bitis tarihini ekrana basar

        style: TextStyle(fontSize: width * 0.06)
    );
  }

  Widget createSaveButton() {
    return RaisedButton(
      child: Text(
        "Kaydet",
        style: TextStyle(fontSize: width * 0.05),
      ),
      onPressed: () {
        if (!resultIsValidate()) {
          // Eger girilen degerler gecerli degilse mesaj gosteriliyor

          final snackBar =
              SnackBar(content: Text('Eksik veya yanlış veri girdiniz !'));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else { //Eger girilen degerler gecerli ise
          insertTask(createTask()); //olusturulan task db'ye kaydedilir
        }
      },
    );
  }

  @override
  void dispose() {
    //ui dispose edildiginde controller nesnesi de dispose ediliyor
    super.dispose();
    _txtController.dispose(); //kullanilmayan controller dispose edilir
  }

  Task createTask() {
    //Ui'da girilen verilerden task nesnesi olusturan method

    Task task = new Task();

    DateTime current = DateTime.now();

    //input'taki degerler task objesine atanir
    task.title = _txtController.text;
    task.beginDate = _beginDate;
    task.finishedDate = _finisDate;

    if (task.beginDate
        .isAfter(current)) //Eger islem daha sonra baslayacak ise
      task.status = "waiting"; //Bekliyor olarak ataniyor

    else //Not gecmis zaten secilemedigi icin tek ihtimal simidiki zaman kaliyor
      task.status = "running"; //Eger baslangic zamani ise running olarak ataniyor

    return task;
  }

  void calculateFinishDate() {//bitis tarihini hesaplayan method

    if (_beginDate != null) {
      // tarih bos degilse baslangic tarihine esitler
      _finisDate = _beginDate;

      Duration duration = new Duration(
          // girilen saat ve tarih eklenir
          hours: _hourValue.toInt(),
          minutes: _minuteValue.toInt());

      _finisDate = _finisDate.add(duration); // ve sonuc bitis tarihi olarak atanir
    }
  }

  getSliderData() {
    //Sliderlarda datalarin gorunmesi saglayan method
    return SliderTheme.of(context).copyWith(
      activeTrackColor: Colors.red[700], //Slider'in secilimis olan yerleri
      inactiveTrackColor: Colors.red[100], //Slider'in secili olmayan rengi
      trackShape: RoundedRectSliderTrackShape(), //Slider track'ini yuvarlar
      trackHeight: 4.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0), //Secici top
      thumbColor: Colors.redAccent, //Top'un rengi
      overlayColor: Colors.red.withAlpha(32), // Top secilince rengi hesaplanir
      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),//secilince olusacak olan shape
      tickMarkShape: RoundSliderTickMarkShape(), //Tick yani aralarindaki secilebileck konumlardaki
      activeTickMarkColor: Colors.red[700], // cizgilerin sekli, aktif ve inaktif renkleri
      inactiveTickMarkColor: Colors.red[100], //Burada gorunmemesi icin ayni yapilmistir
      valueIndicatorShape: PaddleSliderValueIndicatorShape(), //Secilirken uzerinde cikan shape
      valueIndicatorColor: Colors.redAccent, //rengi
      valueIndicatorTextStyle: TextStyle(
        color: Colors.white, //text rengi beyaz
      ),
    );
  }

  bool resultIsValidate() {
    //gecerli bir bitis tarihinin olup olmadigini kontrol eden method
    if (_finisDate != null && // Bitis tarihi bos degilse
        (_hourValue != 0 || _minuteValue != 0) && //saat veya dakika secilmis ise
        _txtController.text.trim().isNotEmpty) return true; //ve baslik bos degilse,true

    return false; //kosullar saglanmaz ise false donderir
  }

  void insertTask(Task task) async {
    // DB'ye task ekliyen method

    var result = await _dataSource.insert(task); //datayi ekler

    if (result != 1) {
      // eger bir hata olusmadiysa
      isSave = true; //kayit bayragi kaldirilir
    }
  }
}
