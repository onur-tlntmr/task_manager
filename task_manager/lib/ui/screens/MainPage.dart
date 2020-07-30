import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_manager/ui/screens/AddPage.dart';
import 'package:task_manager/ui/screens/DailyPage.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/ui/screens/MonthlyPage.dart';
import 'package:task_manager/ui/screens/WeeklyPage.dart';
import 'package:task_manager/utils/DataUpdater.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainState();
  }
}

class MainState extends State {
  int pageCount = 3; //Kaydirilabilen sayfa sayisi

  final double _iconSize = 10; //Allttaki indicator'in boyutu

  var h, w; //ekran cozunurlukleri

  final DataSource dataSource = new DataSource();

  var _dotColors = <Color>[ //indicators renklerini tutan degisken
    Colors.blue,
    Colors.black45,
    Colors.black45,
  ];

//Bu servis notlarin takibini yapar ornegin: olsturulan task tamamlanmamis ise onu tamamlanmamis olarak isaretler
  DataUpdaterService service = DataUpdaterService();





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    initializeDateFormatting('tr'); // Tarih icin yerellestirme yapiliyor

    h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: h * 0.85, //boyutlar yuzdesel olarak verilir
            margin: EdgeInsets.only(top: h * 0.05),
            child: PageView(
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  changeColor(index);
                });
              },
              children: <Widget>[
                DailyPage(),
                WeeklyPage(),
                MonthlyPage()
              ],
            ),
          ),
          Container(
            height: h * 0.03,
            margin: EdgeInsets.only(bottom: h * 0.013),
            child: createIndicator(),
          )
        ],
      ),
      floatingActionButton: actionButton(context),
    );
  }

  @override
  void initState() { //State baslandiginda
    super.initState();
    service.startService(); //servis baslatilir
  }

  @override
  void dispose() {
    super.dispose();
    service.closeService(); //dispose edildiginde servics kapatilir
  }


  Widget createIndicator(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.lens, color: _dotColors[0]),
          iconSize: _iconSize,
        ),
        IconButton(
          icon: Icon(Icons.lens, color: _dotColors[1]),
          iconSize: _iconSize,
        ),
        IconButton(
          icon: Icon(Icons.lens, color: _dotColors[2]),
          iconSize: _iconSize,
        ),
      ],
    );
  }


  void changeColor(int index) { //Secilen page'a gore alttaki noktalarin rengi degistirilir

    for (int i = 0; i < pageCount; i++) {
      if (i == index)  //Secili olan mavi yapilir
        _dotColors[i] = Colors.blue;
      else //Kalanlar ise siyah yapilir
        _dotColors[i] = Colors.black45;
    }

  }

  void goToAdd(BuildContext context) async { //Task ekleme ekranina giden method
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddPage()));
  }

  Widget actionButton(BuildContext context) { //AcionButton olusturan method
    return Container(
      height: h * 0.08,
      width: h * 0.08,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.add),
        ),
        onPressed: () {
          goToAdd(context);
        },
      ),
    ) ;
  }
}
