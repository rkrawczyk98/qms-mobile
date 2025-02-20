import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/language_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageNotifier = ref.watch(languageProvider.notifier);
    final selectedLanguage = languageNotifier.getSelectedLanguage();
    final availableLanguages = languageNotifier.getLanguages();

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedLanguage,
        items: availableLanguages
            .map(
              (item) => DropdownMenuItem<String>(
                value: item['value']!,
                child: Row(
                  children: <Widget>[
                    Image.asset(item['icon']!, width: 24, height: 24),
                    const SizedBox(width: 10),
                    Text(
                      item['text']!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (String? value) {
          if (value != null) {
            languageNotifier.setLanguage(value);
          }
        },
        focusColor: Colors.transparent,
        iconEnabledColor:
            Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
      ),
    );
  }
}
