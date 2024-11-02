import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  LogViewerState createState() => LogViewerState();
}

class LogViewerState extends State<LogViewer> {
  List<File> logFiles = [];
  String? selectedLogContent;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadLogFiles();
  }

  Future<void> _loadLogFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().toList();

    setState(() {
      logFiles = files.where((file) => file.path.endsWith('.txt')).toList();
    });
  }

  Future<void> _readLogFile(File file) async {
    final content = await file.readAsString();
    setState(() {
      selectedLogContent = content;
    });
  }

  Future<void> _clearLogs() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDeletion),
        content: Text(AppLocalizations.of(context)!.deleteAllLogsMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (var file in logFiles) {
        await file.delete();
      }
      setState(() {
        logFiles.clear();
        selectedLogContent = null;
      });
    }
  }

  Future<void> _deleteSingleLog(File file) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteFile),
        content: Text(AppLocalizations.of(context)!.deleteSingleLogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await file.delete();
      _loadLogFiles();
      setState(() {
        if (selectedLogContent != null &&
            file.path.endsWith(selectedLogContent!)) {
          selectedLogContent = null;
        }
      });
    }
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogFiles,
          ),
          if (logFiles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _clearLogs,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: logFiles.length,
              itemBuilder: (context, index) {
                final file = logFiles[index];
                final fileName = file.path.split('/').last;
                return ListTile(
                  title: Text(fileName),
                  onTap: () => _readLogFile(file),
                  onLongPress: () => _deleteSingleLog(file),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            flex: isExpanded ? 10 : 1,
            child: selectedLogContent != null
                ? Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_more : Icons.expand_less,
                        ),
                        onPressed: _toggleExpand,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(selectedLogContent!),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(localizations.selectLogToView),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
