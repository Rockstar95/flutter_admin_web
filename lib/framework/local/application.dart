import 'dart:ui';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  /* List<String> supportedLanguages = [
    "English",
    "Hindi",
     "Arebic"
  ];*/

  List<String> supportedLanguagesCodes = [
    "en",
    "hi",
    "ar",
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback? onLocaleChanged;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);
