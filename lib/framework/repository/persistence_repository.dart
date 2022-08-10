import 'package:shared_preferences/shared_preferences.dart';

class PersistenceRepository {
  static final PersistenceRepository _singleton =
      PersistenceRepository._internal();

  static PersistenceRepository get instance => _singleton;
  static SharedPreferences? _pref;

  PersistenceRepository._internal() {
    initSharedPref();
  }

  Future initSharedPref() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  void setPrefs<T>(String key, T content) async {
    if (content is String) {
      await _pref?.setString(key, content);
    }
    if (content is bool) {
      await _pref?.setBool(key, content);
    }
    if (content is int) {
      await _pref?.setInt(key, content);
    }
    if (content is double) {
      await _pref?.setDouble(key, content);
    }
    if (content is List<String>) {
      await _pref?.setStringList(key, content);
    }
    return;
  }

  dynamic getPrefs(String key, {dynamic defaultValue}) {
    try {
      if (_pref?.containsKey(key) ?? false) {
        return _pref?.get(key);
      } else {
        return defaultValue;
      }
    } catch (e) {
      return null;
    }
  }
}
