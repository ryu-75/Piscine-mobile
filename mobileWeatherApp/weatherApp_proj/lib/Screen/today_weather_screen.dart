import 'package:flutter/material.dart';
import 'package:weather_app_proj/widget/city_widget.dart';

class TodayWeatherScreenView extends StatelessWidget {
  final String?  cityName;

  const TodayWeatherScreenView({this.cityName, super.key});

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
            CityWidget(city: cityName),
          ],
        ),
      ),
    );
  }
}
