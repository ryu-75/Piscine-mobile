import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/api/weather_api.dart';
import 'package:weather_app_v2_proj/widget/city_widget.dart';

class UtilsMethod {
  Widget  selectedPosition(String? cityname, bool? currentPosition) {
    if (cityname != '') {
      return (CityWidget(city: cityname));
    } else if (currentPosition == true) {
      return GetCardinal().getCardinal();
    }
    return Container();
  }
}