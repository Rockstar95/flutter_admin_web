enum EnvironmentType { Production, Staging, UAT, Development }

enum ThemeType { Dark, Light }
enum ThemeModuleType { Type, Common }

enum Status {
  LOADING,
  COMPLETED,
  ERROR,
  CONTACT,
}

enum EnumRequestSourceType {
  Local,
  Server,
}

// Declare Font Here
abstract class FontFamily {
  static const String MierA = 'MierA';
  static const String MierB = 'MierB';
  static const String Graphik = 'Graphik';
  static const String cambon = 'Cambon';
  static const String suisse = 'Suisse';
}

enum ScreenType { MyLearning, Catalog, Events }

enum MessageType { Text, Image, Audio, Video, Doc }

abstract class AppFlavour {
  static const String marketPlace = 'MarketPlace';
  static const String playGround = 'PlayGround';
}
