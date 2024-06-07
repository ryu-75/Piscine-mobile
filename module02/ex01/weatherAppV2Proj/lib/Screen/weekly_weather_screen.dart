import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/api/weather_api.dart';
import 'package:weather_app_v2_proj/utils/utils.dart';
import 'package:weather_app_v2_proj/widget/city_widget.dart';

class WeeklyWeatherScreenView extends StatelessWidget {
  final ValueNotifier<String?>  selectedCity;
  final ValueNotifier<bool> selectedPosition;

  const WeeklyWeatherScreenView({
    required this.selectedCity, 
    required this.selectedPosition, 
    super.key
  });

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
            const SizedBox(height: 50),
            ValueListenableBuilder<String?>(
              valueListenable: selectedCity, 
              builder: (contexte, cityName, child) {
                return ValueListenableBuilder(
                  valueListenable: selectedPosition, 
                  builder: (contexte, currentPos, child) {
                    return UtilsMethod().selectedPosition(cityName, currentPos);
                  }
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
