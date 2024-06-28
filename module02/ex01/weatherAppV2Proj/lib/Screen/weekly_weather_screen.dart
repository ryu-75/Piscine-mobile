import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/utils/utils.dart';

class WeeklyWeatherScreenView extends StatelessWidget {
  final ValueNotifier<String?> selectedCity;
  final ValueNotifier<bool> selectedPosition;
  final List<dynamic> filteredSuggestions;
  final ValueNotifier<String> status;

  const WeeklyWeatherScreenView(
      {required this.selectedCity,
      required this.selectedPosition,
      required this.status,
      this.filteredSuggestions = const [],
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            ValueListenableBuilder<String?>(
                valueListenable: selectedCity,
                builder: (contexte, cityName, child) {
                  return ValueListenableBuilder(
                      valueListenable: selectedPosition,
                      builder: (contexte, currentPos, child) {
                        return UtilsMethod().selectedPosition(
                            cityName, currentPos, status, filteredSuggestions);
                      });
                })
          ],
        ),
      ),
    );
  }
}
