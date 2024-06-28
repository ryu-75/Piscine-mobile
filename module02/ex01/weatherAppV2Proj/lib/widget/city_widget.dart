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
        "${apiUrl}latitude=${widget.filteredSuggestions[0]['lat']}&longitude=${widget.filteredSuggestions[0]['lon']}&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,visibility,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max";
    try {
      final response = await http.get(Uri.parse(completeUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(data['daily']);
        print("\n");
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
            if (weatherData != null && widget.status.value == "weekly")
              weeklyWeather(),
          ],
        ),
      ),
    );
  }

  Column weeklyWeather() {
    Map<String, dynamic> weeklyWeatherData = getWeeklyDate();
    print(weeklyWeatherData);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeklyWeatherData.keys.map<Widget>((value) {
        String label = weeklyWeatherData[value]!;
        int index = weeklyWeatherData.keys.toList().indexOf(value);
        String minusTemp =
            "${weatherData!['daily']['temperature_2m_min'][index]}";
        String maxTemp =
            "${weatherData!['daily']['temperature_2m_max'][index]}";
        String wmoCode = "${weatherData!['daily']['weather_code'][index]}";
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "$minusTemp°C",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "$maxTemp°C",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    wmoCode,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Column currentlyWeather() {
    return Column(
      children: [
        Text(
          "${weatherData!['current']['temperature_2m']}°C",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          "${weatherData!['current']['wind_speed_10m']} Km/h",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Column todayWeather() {
    Map<String, dynamic> timeMap = convertDataFormat();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: timeMap.keys.map<Widget>((time) {
        String label = timeMap[time]!;
        int index = timeMap.keys.toList().indexOf(time);
        String temperature =
            "${weatherData!['hourly']['temperature_2m'][index]}";
        String windSpeed = "${weatherData!['hourly']['wind_speed_10m'][index]}";

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "$temperature°C",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "$windSpeed Km/h",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> convertDataFormat() {
    Map<String, dynamic> timeMap = {};

    if (weatherData != null &&
        weatherData!['hourly'] != null &&
        weatherData!['hourly']['time'] != null) {
      List<dynamic> timeString = weatherData!['hourly']['time'];
      List<dynamic> timeList = [];

      for (int i = 0; i < timeString.length; i++) {
        timeList = timeString[i].split("T");
        if (timeList.length > 1) {
          String time = timeList[1].substring(0, 5);

          timeMap[time] = time;
        }
      }
    }
    return (timeMap);
  }

  Map<String, dynamic> getWeeklyDate() {
    Map<String, dynamic> weeklyData = {};

    if (weatherData != null &&
        weatherData!['daily'] != null &&
        weatherData!['daily']['time'] != null) {
      List<dynamic> timeString = weatherData!['daily']['time'];
      List<dynamic> weeklyList = [];

      for (int i = 0; i < timeString.length; i++) {
        weeklyList = timeString[i].split(',');
        weeklyData[weeklyList[0]] = weeklyList[0];
      }
    }
    return weeklyData;
  }
}
