import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_manager/ui/screens/AddPage.dart';
import 'package:task_manager/ui/screens/AllPage.dart';
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
  final double _iconSize = 10; //Allttaki indicator'in boyutu

  final int pageCount = 4; // Page sayisi

  var h, w; //ekran cozunurlukleri

  final DataSource dataSource = new DataSource();

  List<Color> _dotColors = List(); //nokta renkleri

  PageController _pageController; //page uzerinde islem yapmak icin gerekli

//Bu servis notlarin takibini yapar ornegin: olsturulan task tamamlanmamis ise onu tamamlanmamis olarak isaretler
  DataUpdaterService service = DataUpdaterService();



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    initializeDateFormatting('tr'); // Tarih icin yerellestirme yapiliyor

    h = MediaQuery.of(context).size.height;

    initDotColors();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: h * 0.85, //boyutlar yuzdesel olarak verilir
            margin: EdgeInsets.only(top: h * 0.05),
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  changeColor(index);
                });
              },
              children: <Widget>[ //Pages
                DailyPage(),
                WeeklyPage(),
                MonthlyPage(),
                AllPage()
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
  void initState() {
    //State baslandiginda
    super.initState();
    service.startService(); //servis baslatilir
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    service.closeService(); //dispose edildiginde servics kapatilir
    _pageController.dispose();
  }

  void initDotColors() {
    if (pageCount > 0) {
      _dotColors.add(Colors.blueAccent);

      for (int i = 1; i < pageCount; i++) {
        _dotColors.add(Colors.black45);
      }
    }
  }

  Widget createIndicator() {
    List<Widget> childs = List();

    for (int i = 0; i < pageCount; i++) {
      childs.add(IconButton(
        icon: Icon(Icons.lens, color: _dotColors[i]),
        iconSize: _iconSize,onPressed: (){ //Her bir noktaya basildiginda o'nun oldugu sayfaya gider
          _pageController.animateToPage(i, duration: Duration(milliseconds: 350), curve: Curves.bounceInOut);
      },
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: childs,
    );
  }

  void changeColor(int index) {
    //Secilen page'a gore alttaki noktalarin rengi degistirilir

    for (int i = 0; i < _dotColors.length; i++) {
      if (i == index) //Secili olan mavi yapilir
        _dotColors[i] = Colors.blueAccent;
      else //Kalanlar ise siyah yapilir
        _dotColors[i] = Colors.black45;
    }
  }

  void goToAdd(BuildContext context) async {
    //Task ekleme ekranina giden method
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddPage()));
  }

  Widget actionButton(BuildContext context) {
    //AcionButton olusturan method
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
    );
  }
}
