import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguageChangeController extends ChangeNotifier {
  final Locale _currentLocale = const Locale("en");

  Locale get currentLocale => _currentLocale;

  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  Future<void> initLanguage(String languageCode) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? storedLanguageCode = sp.getString('language_code');
    _appLocale = storedLanguageCode != null ? Locale(storedLanguageCode) : _currentLocale;
    notifyListeners();
  }

void changeLanguage(Locale newLocale) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.setString('language_code', newLocale.languageCode);
  _appLocale = newLocale;
  notifyListeners();
}


}
