import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();

  var formatter = new DateFormat("EEE, MMM d, yyyy hh:mm");
  String formatted = formatter.format(now);

  return formatted;
}
