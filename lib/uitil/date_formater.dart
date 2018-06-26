import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();
  var formatter = new DateFormat("EEE, MMM, ''yy");
  var formatted = formatter.format(now);
  return formatted;
}