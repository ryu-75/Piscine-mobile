import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2_proj/api/api_service.dart';
import 'package:weather_app_v2_proj/model/weather_model.dart';
import 'package:weather_app_v2_proj/utils/geolocation.dart';

class WeatherApi extends StatefulWidget {
  const WeatherApi({super.key});
  
  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  String  data = '';
  final ApiService  _service = ApiService();

  Future<String>  fetchWeatherData() async {
    final response = await _service.fetchWeatherData();
    if (response.statusCode == 200) {
      data = response.body;
      print(data);
      return data;
    } else {
      throw Exception("Data can't be retrieve");
    }
  } 

  @override
  Widget  build(BuildContext context) {
    // List<WeatherModel>  weatherData = [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: fetchWeatherData,
          child: const Text('Fetch data'),
        ),
        // const SizedBox(height: 20),
        Text(data),
        // SizedBox(
        //   height: 100,
        //   width: 100,
        //   child: ListView.builder(
        //     itemCount: weatherData.length,
        //     itemBuilder: (context, index) {
        //       final weathers = weatherData[index];
        //       // final latitude = weathers.latitude;
        //       final longitude = weathers.longitude;
        //       // final current = weathers.current;
        //       // final temperatureUnit = weathers.temperatureUnit;
        //       // final forecastDays = weathers.forecastDays;
        //       return ListTile(
        //         title: Text(longitude.toString()),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
