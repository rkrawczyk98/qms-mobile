import 'package:intl/intl.dart';

extension NullableDateTimeFormat on DateTime? {
  /// Formats a nullable DateTime to a string with date and time. Returns null if the object is null.
  String? formatToNullableDateTime() {
    DateFormat dateFormat = DateFormat.yMd().add_Hm();
    return this != null ? dateFormat.format(this!) : null;
  }

  /// Forces formatting of a nullable DateTime to a string with date and time. Assumes the object is not null.
  String forceFormatToDateTime() {
    DateFormat dateFormat = DateFormat.yMd().add_Hm();
    return dateFormat.format(this!);
  }

  /// Formats a nullable DateTime to a string with only the date. Returns null if the object is null.
  String? formatToNullableDate() {
    DateFormat dateFormat = DateFormat.yMd();
    return this != null ? dateFormat.format(this!) : null;
  }

  /// Forces formatting of a nullable DateTime to a string with only the date. Assumes the object is not null.
  String forceFormatToDate() {
    DateFormat dateFormat = DateFormat.yMd();
    return dateFormat.format(this!);
  }
}

extension DateTimeFormat on DateTime {
  /// Formats a DateTime to a string with date and time.
  String formatToDateTime() {
    DateFormat dateTimeFormat = DateFormat.yMd().add_Hm();
    return dateTimeFormat.format(this);
  }

  /// Formats a DateTime to a string with only the date.
  String formatToDate() {
    DateFormat dateFormat = DateFormat.yMd();
    return dateFormat.format(this);
  }
}
