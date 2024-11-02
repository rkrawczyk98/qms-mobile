import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension Translate on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}

// StateNotifier that manages language selection and localization state
class LanguageNotifier extends StateNotifier<Locale> {
  final List<Map<String, String>> languageItems;

  LanguageNotifier()
      : languageItems = [
          {'value': 'pl', 'icon': 'images/flag_pl.png', 'text': 'Polski'},
          {'value': 'en', 'icon': 'images/flag_uk.png', 'text': 'English'},
        ],
        super(const Locale('pl')); // Default locale

  // Function to get the list of languages
  List<Map<String, String>> getLanguages() => languageItems;

  // Function to set the selected language and update Locale
  void setLanguage(String languageCode) {
    state = Locale(languageCode);
  }

  // Function to get the current selected language code
  String getSelectedLanguage() => state.languageCode;

  Locale getLocale() => state;
}

// Provider that uses LanguageNotifier to manage state
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});
