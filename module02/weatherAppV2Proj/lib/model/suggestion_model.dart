import 'package:flutter/material.dart';

class SuggestionModel with ChangeNotifier {
  List<dynamic> _filteredSuggestion = [];

  List<dynamic> get filteredSuggestion => _filteredSuggestion;

  void updateSuggestions(List<dynamic> suggestions) {
    _filteredSuggestion = suggestions;
    notifyListeners();
  }
}
