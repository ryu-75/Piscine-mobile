import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CityWidget extends StatefulWidget {
  final String? city;
  final ValueNotifier<String> status;
  final List<dynamic> filteredSuggestions;

  const CityWidget(
      {super.key,
      this.city,
      required this.status,
      this.filteredSuggestions = const []});

  @override
  State<CityWidget> createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  Map<String, dynamic>? weatherData;
  String apiUrl = "https://api.open-meteo.com/v1/forecast?";

  @override
  void initState() {
    super.initState();
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
        "${apiUrl}latitude=${widget.filteredSuggestions[0]['lat']}&longitude=${widget.filteredSuggestions[0]['lon']}&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,wind_speed_10m";
    try {
      final response = await http.get(Uri.parse(completeUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // print(data['hourly']);
        // print("\n");
        // print(data['hourly']['temperature_2m']);
        // print("\n");
        // print(data['hourly']['wind_speed_10m']);
        // print("\n");
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
    return Flexible(
      flex: 1,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              splitLocation?[0] ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            if (splitLocation != null && splitLocation.length > 1)
              Text(
                splitLocation[1],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 2),
            if (splitLocation != null && splitLocation.length > 2)
              Text(
                splitLocation[2],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 2),
            if (weatherData != null && widget.status.value == "currently")
              currentlyWeather(),
            if (weatherData != null && widget.status.value == "today")
              todayWeather(),
          ],
        ),
      ),
    );
  }

  Column currentlyWeather() {
    return Column(
      children: [
        Text(
          "${weatherData!['current']['temperature_2m']}°C",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "${weatherData!['current']['wind_speed_10m']} Km/h",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Column todayWeather() {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: weatherData!['hourly'].keys.map<Widget>((key) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...List<Widget>.generate(
                      weatherData!['hourly'][key].length,
                      (index) => Text(
                        "${weatherData!['hourly'][key][index]}",
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
