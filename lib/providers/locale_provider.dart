import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('vi');

  Locale get locale => _locale;

  Future fetchLocale() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('language_code')) {
      _locale = Locale(prefs.getString('language_code')!);
    } else {
      final String deviceLanguageCode = Platform.localeName.split('_').first;

      if (L10n.all.contains(Locale(deviceLanguageCode))) {
        _locale = Locale(deviceLanguageCode);
        await prefs.setString('language_code', deviceLanguageCode);
      } else {
        _locale = const Locale('vi');
        await prefs.setString('language_code', 'vi');
      }
    }
    notifyListeners();
  }

  Future changeLocale(Locale locale) async {
    if (_locale == locale) {
      return;
    }

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }
}
