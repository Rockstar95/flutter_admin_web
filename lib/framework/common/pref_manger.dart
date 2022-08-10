import 'package:shared_preferences/shared_preferences.dart';

//##########################  ------- Save & get SharePreference -------- ####################################
Future<void> sharePrefSaveString(String key, String value) async {
  print("Shared Preference Save String Called with Key:$key, Value:$value");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> sharePrefGetString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String value = prefs.getString(key) ?? "";
  return value;
}

Future<void> sharePrefSaveInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, value);
}

Future<void> sharePrefSaveBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<int> sharePrefGetInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int value = prefs.getInt(key) ?? 0;
  return value;
}

Future<bool> sharePrefGetBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool value = prefs.getBool(key) ?? false;
  return value;
}
