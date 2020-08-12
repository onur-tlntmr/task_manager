import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_manager/ui/screens/AddPage.dart';
import 'package:task_manager/ui/screens/AllPage.dart';
import 'package:task_manager/ui/screens/DailyPage.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/ui/screens/MonthlyPage.dart';
import 'package:task_manager/ui/screens/WeeklyPage.dart';
import 'package:task_manager/utils/DataUpdateService.dart';

/*
 Bu sinif tum sayfalarin tasiyicisi konumundadir
* */
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return MainState();
  }
}

class MainState extends State {
  final double _indicatorIconSize = 10; //Allttaki indicator'in boyutu

  final int pageCount = 4; // Page sayisi

  var h, w; //ekran cozunurlukleri

  final DataSource dataSource = new DataSource(); //Db operasyonlari icin gerekli

  List<Color> _dotColors = List(); //nokta renklerini tutan collection

  PageController _pageController; //page'lerin arasinda gezinmek icin gerekli

//Bu servis tasklarin takibini yapar ornegin: olsturulan task tamamlanmamis ise onu tamamlanmamis olarak isaretler
  DataUpdaterService service = DataUpdaterService();



  @override
  Widget build(BuildContext context) {
    
    initializeDateFormatting('tr'); // Tarih icin yerellestirme yapiliyor

    h = MediaQuery.of(context).size.height; //Ekranin yukseklik bilgisini alir

    initDotColors(); //_dotColors'a elemanlari ekler

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: h * 0.85, //boyutlar yuzdesel olarak verilir
            margin: EdgeInsets.only(top: h * 0.05),
            child: createPageView(), //Sayfalarin bulundugu widget
          ),
          Container(
            height: h * 0.03,
            margin: EdgeInsets.only(bottom: h * 0.013),
            child: createIndicator(), //Indicator olusturur
          )
        ],
      ),
      floatingActionButton: addActionButton(context), //Task ekleyen button
    );
  }

  @override
  void initState() {
    //State baslandiginda
    super.initState();
    service.startService(); //Task'larin durum bilgisini takib eden servisi baslatir
    _pageController = PageController(initialPage: 0); //Page controller ataniyor secili elemani 0 olarak ayarlaniyor
  }

  @override
  void dispose() {
    super.dispose();
    service.closeService(); //dispose edildiginde servis kapatilir
    _pageController.dispose(); //pageController'da hafizdan ucurulur
  }

  Widget createPageView(){ //PageView Widget'ini donduren method
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal, //Yatay scroll attribute
      onPageChanged: (index) {
        setState(() {
          changeColor(index); //Page Degisme eventi yakalaniyor
        });
      },
      children: <Widget>[ //Pages
        DailyPage(),
        WeeklyPage(),
        MonthlyPage(),
        AllPage()
      ],
    );
  }


  void initDotColors() { //Indicator renklerini collection'a ekler
    if (pageCount > 0) {
      _dotColors.add(Colors.blueAccent); //ilk olan secili olacagi icin mavi yapilir

      for (int i = 1; i < pageCount; i++) {
        _dotColors.add(Colors.black45);
      }
    }
  }

  Widget createIndicator() { //IndicatorWidget'ini olsturur
    List<Widget> children = List(); //Buttonlarin tutuldugu yapi

    for (int i = 0; i < pageCount; i++) { //Page sayisi kadar buton olusturulur
      children.add(IconButton(
        icon: Icon(Icons.lens, color: _dotColors[i]),  //Iconlar olusturuluyor ve renkleri sirasiyla ataniyor
        iconSize: _indicatorIconSize, //Boyutlari ataniyor
        onPressed: (){ //Basildigi sayfaya gider
          _pageController.animateToPage(i, duration: Duration(milliseconds: 350), curve: Curves.bounceInOut);
      },
      ));
    }
    return Row(//Noktalari ayni satirda tutar
      mainAxisAlignment: MainAxisAlignment.center, //Merkeze alir
      children: children,
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

  Widget addActionButton(BuildContext context) {
    //ActionButton olusturan method
    return Container(
      height: h * 0.08, //genisligin ve yuksekligin %8'i kadar
      width: h * 0.08, //boyutlarndirilir
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.add,color: Colors.black87,), 
          onPressed: () { //Tiklaninca
          goToAdd(context); //Task ekleme ekranina gider
        },
        ),
        onPressed: () => {}, //Bos callback method
      ),
    );
  }
}
