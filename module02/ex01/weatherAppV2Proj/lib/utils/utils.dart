import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/api/weather_api.dart';
import 'package:weather_app_v2_proj/widget/city_widget.dart';

class UtilsMethod {
  Widget selectedPosition(String? cityname, bool? currentPosition,
      String? status, List<dynamic> filteredSuggestions) {
    if (cityname != '') {
      return (CityWidget(
          city: cityname, filteredSuggestions: filteredSuggestions));
    } else if (currentPosition == true) {
      return GetCardinal().getCardinal();
    }
    return Container();
  }
}
