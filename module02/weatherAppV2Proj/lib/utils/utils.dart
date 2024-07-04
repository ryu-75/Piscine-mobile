import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/api/weather_api.dart';
import 'package:weather_app_v2_proj/widget/city_widget.dart';
import 'package:weather_app_v2_proj/widget/connectivity.dart';

class UtilsMethod {
  Widget selectedPosition(String? cityname, bool? currentPosition,
      ValueNotifier<String> status, List<dynamic> filteredSuggestions) {
    if (cityname != "") {
      return (CityWidget(
          city: cityname,
          filteredSuggestions: filteredSuggestions,
          status: status));
    } else if (currentPosition == true) {
      return const GetCardinal();
    }
    return Container();
  }
}
