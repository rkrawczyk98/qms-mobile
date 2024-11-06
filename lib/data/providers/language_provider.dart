import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/user_module/preferences_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension Translate on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}

class LanguageNotifier extends StateNotifier<Locale> {
  final List<Map<String, String>> languageItems;

  LanguageNotifier()
      : languageItems = [
          {'value': 'pl', 'icon': 'images/flag_pl.png', 'text': 'Polski'},
          {'value': 'en', 'icon': 'images/flag_uk.png', 'text': 'English'},
        ],
        super(const Locale('pl')) {
    _initializeLanguage();
  }

  Future<void> _initializeLanguage() async {
    final savedLanguageCode = await preferencesService.getLanguageCode();
    if (savedLanguageCode != null) {
      state = Locale(savedLanguageCode);
    }
  }

  List<Map<String, String>> getLanguages() => languageItems;

  void setLanguage(String languageCode) {
    state = Locale(languageCode);
    preferencesService.saveLanguageCode(languageCode);
  }

  String getSelectedLanguage() => state.languageCode;
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});
