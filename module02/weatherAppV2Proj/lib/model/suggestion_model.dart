import 'package:flutter/material.dart';

class SuggestionModel with ChangeNotifier {
  List<dynamic> _filteredSuggestion = [];
  String _errorMessage = '';

  List<dynamic> get filteredSuggestion => _filteredSuggestion;
  String get errorMessage => _errorMessage;

  void updateSuggestions(List<dynamic> suggestions) {
    _filteredSuggestion = suggestions;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
