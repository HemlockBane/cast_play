import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getFormattedDate(String? dateString,
      [String format = "dd/MM/yyyy"]) {
    final dateTime = DateTime.tryParse(dateString ?? "");
    if (dateTime == null) {
      return "--";
    }
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }
}
