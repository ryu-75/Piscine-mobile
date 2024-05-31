import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/api/weather_api.dart';
import 'package:weather_app_v2_proj/utils/utils.dart';
import 'package:weather_app_v2_proj/widget/city_widget.dart';

class TodayWeatherScreenView extends StatelessWidget {
  final String? cityName;
  final bool?    currentPosition;

  const TodayWeatherScreenView({this.cityName, this.currentPosition, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Today",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            UtilsMethod().selectedPosition(cityName, currentPosition),
          ],
        ),
      ),
    );
  }
}
