import 'package:intl/intl.dart';

class Utils{

  String toDoubleDigit(int x){

    String str = x.toString();

    if(x<10)
      str = "0"+str;

    return str;
  }

  String dateFormatter(DateTime dateTime) {

    //tarih ve saati uygun formata ceviren method
    if (dateTime == null) return "";

    var hour = dateTime.hour;
    var minute = dateTime.minute;

    var strHour, strMinute;

    var result = DateFormat.MMMd('tr_TR')
        .format(dateTime); // ay ve gun turkiyeye uygun hale getliriliyor

    strHour = toDoubleDigit(hour);
    strMinute = toDoubleDigit(minute);


    return result +
        "   $strHour:$strMinute"; //saat tarihin yanına ilistiriliyor
  }



  String getLocalDay(DateTime dateTime){

    return DateFormat.EEEE("tr_TR").format(dateTime);

  }



}