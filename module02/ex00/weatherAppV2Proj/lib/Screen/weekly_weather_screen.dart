import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/widget/city_widget.dart';

class WeeklyWeatherScreenView extends StatelessWidget {
  final String? cityName;

  const WeeklyWeatherScreenView ({this.cityName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Weekly",
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
