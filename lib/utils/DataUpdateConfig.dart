import 'dart:convert';
import 'package:flutter/services.dart';


/* Bu sinif assets\config\data_updater_service dosyasindaki verilerin,
   DataUpdateService sinfi tarafindan kullanilmasini saglayan bir 
   dataClasstir.
 */
class DataUpdateConfig { 

  //Bu deger sabit ve servisin baslamasi icin gerekli oldugu icin final olarak belirlenmistir
  final int periodSeconds; //Servis'in hangi araliklar ile calisacagini saniye cinsinden belirler

  static const _url = 'assets/config/data_updater_service.json'; //Json dosyasinin konumu

  //Not: final olan degiskenler icin gerekli alanlar 
  DataUpdateConfig(this.periodSeconds); //Constructor

  static Future<DataUpdateConfig> createInstance() async {
    final contents = await rootBundle.loadString(_url);

    final json = jsonDecode(contents);

    final int value = json['timer_period'].toInt();


    return DataUpdateConfig(value);
  }
}
