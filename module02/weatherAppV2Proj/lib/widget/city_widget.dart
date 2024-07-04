import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2_proj/enum/wmo_type.dart';

class CityWidget extends StatefulWidget {
  final String? city;
  final ValueNotifier<String> status;
  final List<dynamic> filteredSuggestions;

  const CityWidget({
    super.key,
    this.city,
    required this.status,
    required this.filteredSuggestions,
  });

  @override
  State<CityWidget> createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  Map<String, dynamic>? weatherData;
  final String apiUrl = "https://api.open-meteo.com/v1/forecast?";

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
        if (mounted) {
          setState(() {
            weatherData = data;
          });
        }
      } else {
        throw Exception("Weather data cannot be fetched.");
      }
    } catch (e) {
      throw Exception("Weather data cannot be fetched.");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String>? splitLocation = widget.city?.split(",");
    if (widget.filteredSuggestions.isNotEmpty && (splitLocation != null)) {
      return Flexible(
        flex: 1,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 2),
              Text(
                splitLocation![0],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              if (splitLocation.length > 1)
                Text(
                  splitLocation[1],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 2),
              if (splitLocation.length > 2)
                Text(
                  splitLocation[2],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 2),
              if (weatherData != null) ...[
                if (widget.status.value == "currently") currentlyWeather(),
                if (widget.status.value == "today") todayWeather(),
                if (widget.status.value == "weekly") weeklyWeather(),
              ]
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget weeklyWeather() {
    if (weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    Map<String, dynamic> weeklyWeatherData = getWeeklyData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeklyWeatherData.keys.map<Widget>((date) {
        int index = weeklyWeatherData.keys.toList().indexOf(date);
        String minTemp =
            "${weatherData!['daily']['temperature_2m_min'][index]}";
        String maxTemp =
            "${weatherData!['daily']['temperature_2m_max'][index]}";
        String wmoCode = WmoTypeHelper.getDescription(
            weatherData!['daily']['weather_code'][index]);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(date, style: const TextStyle(fontSize: 16)),
              Text("$minTemp°C", style: const TextStyle(fontSize: 16)),
              Text("$maxTemp°C", style: const TextStyle(fontSize: 16)),
              Text(wmoCode, style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget currentlyWeather() {
    if (weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }
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

  Widget todayWeather() {
    if (weatherData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    Map<String, dynamic> timeMap = convertDataFormat();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: timeMap.keys.map<Widget>((time) {
        int index = timeMap.keys.toList().indexOf(time);
        String temperature =
            "${weatherData!['hourly']['temperature_2m'][index]}";
        String windSpeed = "${weatherData!['hourly']['wind_speed_10m'][index]}";
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(timeMap[time]!, style: const TextStyle(fontSize: 16)),
              Text("$temperature°C", style: const TextStyle(fontSize: 16)),
              Text("$windSpeed Km/h", style: const TextStyle(fontSize: 16)),
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
      for (String timeString in weatherData!['hourly']['time']) {
        List<String> timeList = timeString.split("T");
        if (timeList.length > 1) {
          String time = timeList[1].substring(0, 5);
          timeMap[time] = time;
        }
      }
    }
    return timeMap;
  }

  Map<String, dynamic> getWeeklyData() {
    Map<String, dynamic> weeklyData = {};
    if (weatherData != null &&
        weatherData!['daily'] != null &&
        weatherData!['daily']['time'] != null) {
      for (String timeString in weatherData!['daily']['time']) {
        List<String> weeklyList = timeString.split(',');
        weeklyData[weeklyList[0]] = weeklyList[0];
      }
    }
    return weeklyData;
  }
}
