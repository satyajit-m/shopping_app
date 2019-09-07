/*
  Author: Debadutta Padhial
*/

List<String> month = ["Zero", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
List<String> weekDay = ["Zero","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

String beautifulDate(DateTime uglyObject) {
  
  String wd = weekDay[uglyObject.weekday];
  String m = month[uglyObject.month];
  String d = uglyObject.day.toString();
  String y = uglyObject.year.toString();

  String hh = (uglyObject.hour == 12 || uglyObject.hour == 0 )  ?  "12" : (uglyObject.hour % 12).toString();
  String mm = uglyObject.minute.toString();
  String twelve = uglyObject.hour > 12 ? "PM" : "AM";
  if (uglyObject.day == 1) d += "st";
  else if (uglyObject.day == 2) d += "nd";
  else if (uglyObject.day == 3) d += "rd";
  else d += "th";

  if (hh.length == 1) hh = '0' + hh;
  if (mm.length == 1) mm = '0' + mm;

  return "$hh:$mm $twelve, $wd, $d $m, $y";
}
String beautifulDateOnly(DateTime uglyObject) {
  
  String m = month[uglyObject.month];
  String d = uglyObject.day.toString();
  String y = uglyObject.year.toString();

  String hh = (uglyObject.hour == 12 || uglyObject.hour == 0 )  ?  "12" : (uglyObject.hour % 12).toString();
  String mm = uglyObject.minute.toString();
  String twelve = uglyObject.hour > 12 ? "PM" : "AM";
  if (uglyObject.day == 1) d += "st";
  else if (uglyObject.day == 2) d += "nd";
  else if (uglyObject.day == 3) d += "rd";
  else d += "th";

  if (hh.length == 1) hh = '0' + hh;
  if (mm.length == 1) mm = '0' + mm;

  return "$hh:$mm $twelve, $d $m, $y";
}
