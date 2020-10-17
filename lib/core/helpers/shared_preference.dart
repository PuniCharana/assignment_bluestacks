import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String isLoggedInKey = "is_logged_in";

  static SharedPreferences _prefs;

  static final SharedPreferencesHelper _singleton =
      SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _singleton;
  }

  SharedPreferencesHelper._internal();

  Future<SharedPreferences> getPreferences() async {
    if (_prefs == null)
      return await SharedPreferences.getInstance();
    else
      return _prefs;
  }

  Future<bool> isLoggedIn() async {
    _prefs = await getPreferences();
    bool isLoggedIn = _prefs.getBool(isLoggedInKey);
    if (isLoggedIn == null) {
      return false;
    }
    return isLoggedIn;
  }

  Future setIsLoggedIn(bool isLoggedIn) async {
    _prefs = await getPreferences();
    _prefs.setBool(isLoggedInKey, isLoggedIn);
  }

  Future<bool> clearPreferences() async {
    _prefs = await getPreferences();
    return _prefs.clear();
  }
}
