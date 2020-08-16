import 'package:intl/intl.dart';

/*Yerel ozgun zaman formatlari icin gerekli araclar*/
class DateUtils {
  //girilen sayi 10'dan kucuk ise basina 0 getirir ve string olarak geri donderir
  String toDoubleDigit(int x) {
    String str = x.toString();

    if (x < 10) str = "0" + str;

    return str;
  }

  //Parametre olarak verilen zamani ozgun formatta gostmermek icin string'e donusturur
  String dateFormatter(DateTime dateTime) {
    //tarih ve saati uygun formata ceviren method
    if (dateTime == null) return "";

    var hour = dateTime.hour; //Saat
    var minute = dateTime.minute; //dakika

    var strHour, strMinute; //Saat ve dakikayi tutar.

    var result = DateFormat.MMMd('tr_TR')
        .format(dateTime); // ay ve gun turkiyeye uygun hale getliriliyor

    //Donusumler yapiliyor
    strHour = toDoubleDigit(hour);
    strMinute = toDoubleDigit(minute);

    return result +
        "   $strHour:$strMinute"; //saat tarihin yanına ilistiriliyor
  }

  //Parametre olarak verilen zamandan local gunu verir
  //Ornek olarak 8/8/2020 => 'Cumartesi'
  String getLocalDay(DateTime dateTime) {
    return DateFormat.EEEE("tr_TR")
        .format(dateTime); //Yerel gun formatina donusturuluyor
    //Ve geri donderiliyor
  }



  /*
  Girilen dateTime verisini sql tarihinde donusturur.
  Bu donusumde sadece tarih bilgilisi geri donderilir.

  Ornek: String hali '1969-07-20 20:18:04Z' olan bir tarihten

  '1969-07-20' geri donderilir.

   */
  String getSqlDateFormat(DateTime dateTime) { 
    String strDateTime = dateTime.toString(); //Tarih string' donusturuluyor

    return strDateTime.substring(0, 10); //ilk 10 karakter geri donderiliyor 
  }                                       
}
