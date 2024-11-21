import 'package:intl/intl.dart';

const Map<String, Map<String, String>> dayShortcuts = {
  'pl': {
    'poniedziałek': 'pon.',
    'wtorek': 'wt.',
    'środa': 'śr.',
    'czwartek': 'czw.',
    'piątek': 'pt.',
    'sobota': 'sob.',
    'niedziela': 'niedz.',
  },
  'en': {
    'Monday': 'Mon.',
    'Tuesday': 'Tue.',
    'Wednesday': 'Wed.',
    'Thursday': 'Thu.',
    'Friday': 'Fri.',
    'Saturday': 'Sat.',
    'Sunday': 'Sun.',
  },
};

String formatDate(DateTime? date, {String locale = 'pl'}) {
  final DateFormat dayFormatter = DateFormat.EEEE(locale);
  final DateFormat dateFormatter = DateFormat('dd.MM.yyyy', locale);
  final DateFormat timeFormatter = DateFormat('HH:mm', locale);

  if (date != null) {
    String dayOfWeek = dayFormatter.format(date);
    String formattedDayOfWeek =
        dayShortcuts[locale]?[dayOfWeek] ?? dayOfWeek;
    String formattedDate = dateFormatter.format(date);
    String formattedTime = timeFormatter.format(date);

    return '$formattedDayOfWeek | $formattedDate | $formattedTime';
  } else {
    return locale == 'pl' ? 'Brak informacji' : 'No information';
  }
}
