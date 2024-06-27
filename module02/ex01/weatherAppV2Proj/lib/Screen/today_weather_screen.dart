import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/utils/utils.dart';

class TodayWeatherScreenView extends StatelessWidget {
  final ValueNotifier<String?> selectedCity;
  final ValueNotifier<bool> selectedPosition;
  final List<dynamic> filteredSuggestions;

  const TodayWeatherScreenView(
      {required this.selectedCity,
      required this.selectedPosition,
      this.filteredSuggestions = const [],
      super.key});

  @override
  Widget build(BuildContext context) {
    String status = "today";
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            ValueListenableBuilder<String?>(
              valueListenable: selectedCity,
              builder: (context, cityName, child) {
                return ValueListenableBuilder<bool>(
                    valueListenable: selectedPosition,
                    builder: (context, currentPos, child) {
                      return UtilsMethod().selectedPosition(
                          cityName, currentPos, status, filteredSuggestions);
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
