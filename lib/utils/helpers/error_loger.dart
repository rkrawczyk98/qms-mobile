import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ErrorLogger {
  // Saving error to file
  static Future<void> logError(String error) async {
    final directory = await getApplicationDocumentsDirectory();
    final date =
        DateTime.now().toIso8601String().split('T').first; // Używamy tylko daty
    final file = File('${directory.path}/error_logs_$date.txt');

    final timestamp = DateTime.now().toString();
    final logEntry = '[$timestamp] $error\n';

    await file.writeAsString(logEntry, mode: FileMode.append, flush: true);
  }

  // Reading the contents of the log file
  static Future<String> readLogs() async {
    final directory = await getApplicationDocumentsDirectory();
    final date = DateTime.now().toIso8601String().split('T').first;
    final file = File('${directory.path}/error_logs_$date.txt');
    return await file.readAsString();
  }
}
