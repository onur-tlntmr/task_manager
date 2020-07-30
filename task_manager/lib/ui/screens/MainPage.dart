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
  int pageCount = 3;
  final double _iconSize = 10;
  var h, w;

  final DataSource dataSource = new DataSource();

  DataUpdaterService service = DataUpdaterService();

  void init() {
    service.startService();
  }

  @override
  void dispose() {
    super.dispose();
    service.closeService();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    initializeDateFormatting('tr'); // Tarih icin yerellestirme yapiliyor

    h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: h * 0.85,
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
            child: Row(
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
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        height: h * 0.08,
        width: h * 0.08,
        child: actionButton(context),
      ),
    );
  }

  var _dotColors = <Color>[
    Colors.blue,
    Colors.black45,
    Colors.black45,
  ];

  void changeColor(int index) {
    for (int i = 0; i < pageCount; i++) {
      if (i == index)
        _dotColors[i] = Colors.blue;
      else
        _dotColors[i] = Colors.black45;
    }
  }

  void goToAdd(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddPage()));
  }

  FloatingActionButton actionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(Icons.add),
      ),
      onPressed: () {
        goToAdd(context);
      },
    );
  }
}
