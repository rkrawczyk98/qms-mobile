import 'package:intl/intl.dart';

extension NullableDateTimeFormat on DateTime? {
  String? formatNullableToDateTime() {
    DateFormat dateFormat = DateFormat.yMd().add_Hm();
    return this != null ? dateFormat.format(this!) : null;
  }
}

extension DateTimeFormat on DateTime {
  String? formatToDateTime() {
    DateFormat dateFormat = DateFormat.yMd().add_Hm();
    return dateFormat.format(this);
  }
}
