import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CityWidget extends StatefulWidget {
  final String? city;
  final String? status;
  final List<dynamic> filteredSuggestions;

  const CityWidget(
      {super.key, this.city, this.status, this.filteredSuggestions = const []});

  @override
  State<CityWidget> createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  late String status;
  Map<String, dynamic>? weatherData;
  String apiUrl = "https://api.open-meteo.com/v1/forecast?";

  @override
  void initState() {
    super.initState();
    status = widget.status ?? "";
    if (widget.filteredSuggestions.isNotEmpty) {
      fetchWeatherData();
    }
  }

  @override
  void didUpdateWidget(CityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filteredSuggestions != oldWidget.filteredSuggestions &&
        widget.filteredSuggestions.isNotEmpty) {
      fetchWeatherData();
    }
  }

  Future<void> fetchWeatherData() async {
    final completeUrl =
        "${apiUrl}latitude=${widget.filteredSuggestions[0]['lat']}&longitude=${widget.filteredSuggestions[0]['lon']}&current=temperature_2m,wind_speed_10m&hourly=temperature_2m";
    try {
      final response = await http.get(Uri.parse(completeUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        setState(() {
          weatherData = data;
        });
      } else {
        throw Exception("Weather data cannot be fetched.");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Weather data cannot be fetched.");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.filteredSuggestions.isNotEmpty);

    List<String>? splitLocation = widget.city?.split(",");
    return Column(
      children: [
        Text(
          splitLocation?[0] ?? "",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (splitLocation != null && splitLocation.length > 1)
          Text(
            splitLocation[1],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (splitLocation != null && splitLocation.length > 2)
          Text(
            splitLocation[2],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (weatherData != null && status == "currently") ...[
          Text(
            "Température: ${weatherData!['current']['temperature_2m']}°C",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Vitesse du vent: ${weatherData!['current']['wind_speed_10m']} Km/h",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
