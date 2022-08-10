import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  late Locale locale;
  static Map<dynamic, dynamic> _localisedValues = {};

  AppTranslations(Locale locale) {
    this.locale = locale;
  }

  static AppTranslations? of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    AppTranslations appTranslations = AppTranslations(locale);

    try {
      String jsonContent = await rootBundle.loadString("lang/localization_${locale.languageCode}.json");
      _localisedValues = json.decode(jsonContent);
    }
    catch(e, s) {
      print("Error:$e");
      print(s);
    }

    return appTranslations;
  }

  get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }
}
