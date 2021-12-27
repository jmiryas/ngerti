import 'package:flutter/material.dart';

class LangaugeCollectionProvider extends ChangeNotifier {
  String _selectedFlag = "";
  String _selectedLanguage = "";

  String get selectedLanguage => _selectedLanguage;
  String get selectedFlag => _selectedFlag;

  void changeSelectedLanguageCollection(String language, String flag) {
    _selectedLanguage = language;
    _selectedFlag = flag;

    notifyListeners();
  }

  void clearSelectedLanguageCollection(String language, String flag) {
    _selectedLanguage = _selectedLanguage == language ? "" : language;
    _selectedFlag = _selectedFlag == flag ? "" : flag;

    notifyListeners();
  }
}
