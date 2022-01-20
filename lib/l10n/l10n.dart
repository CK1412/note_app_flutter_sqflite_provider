import 'package:flutter/material.dart';

class L10n {
  static const all = [
    Locale('vi'),
    Locale('en'),
    Locale('ar'), // tiếng Ả Rập
  ];

  static String getLanguage({required String code}) {
    switch (code) {
      case 'vi':
        return 'Tiếng Việt (vi)';
      case 'en':
        return 'English (en)';
      case 'ar':
        return 'العربية (ar)';
      default:
        return '';
    }
  }
}
