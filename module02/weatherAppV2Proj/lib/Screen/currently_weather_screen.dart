import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/api/api_service.dart';
import 'package:weather_app_v2_proj/utils/utils.dart';

class CurrentlyWeatherScreenView extends StatelessWidget {
  final ValueNotifier<String?> selectedCity;
  final ValueNotifier<bool> selectedPosition;
  final ApiService apiService = const ApiService();
  final List<dynamic> filteredSuggestions;
  final ValueNotifier<String> status;

  const CurrentlyWeatherScreenView(
      {required this.selectedCity,
      required this.selectedPosition,
      required this.status,
      required this.filteredSuggestions,
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
              builder: (context, cityName, child) {
                return ValueListenableBuilder<bool>(
                  valueListenable: selectedPosition,
                  builder: (BuildContext context, bool currentPos, child) {
                    return UtilsMethod().selectedPosition(
                        cityName, currentPos, status, filteredSuggestions);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
