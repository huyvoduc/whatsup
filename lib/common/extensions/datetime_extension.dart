
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toBirthDayString() {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }
}


