import 'package:intl/intl.dart';

class Period {
  int month, year;

  Period(this.month, this.year);

  String get monthStr {
    return DateFormat('MMMM').format(DateTime(0, month));
  }

  Period nextMonth() {
    if (month == DateTime.december) {
      month = DateTime.january;
      year++;
    } else {
      month++;
    }

    return this;
  }

  Period prevMonth() {
    if (month == DateTime.january) {
      month = DateTime.december;
      year--;
    } else {
      month--;
    }

    return this;
  }

  Period clone() {
    return Period(month, year);
  }

  String asId() {
    final month = this.month < 10 ? '0${this.month}' : this.month;
    return '$year-$month $monthStr';
  }

  String asTitle() {
    return '$monthStr $year';
  }
}
