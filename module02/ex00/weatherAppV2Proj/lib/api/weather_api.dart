import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2_proj/api/api_service.dart';
import 'package:weather_app_v2_proj/model/weather_model.dart';
import 'package:weather_app_v2_proj/utils/geolocation.dart';
import 'package:weather_app_v2_proj/widget/pop_up_validation.dart';

class WeatherApi extends StatefulWidget {
  const WeatherApi({super.key});
  
  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  Map<String, dynamic>?  dataArray;
  final ApiService  _service = ApiService();
  String data = '';
  Future<Map<String, dynamic>>  fetchWeatherData() async {
    final response = await _service.fetchWeatherData();
    if (response.statusCode == 200) {
      data = response.body;
      dataArray = jsonDecode(data);
      return dataArray!;
    } else {
      throw Exception("Data can't be retrieve");
    }
  } 

  @override
  Widget  build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        FutureBuilder(
          future: determinePosition(),
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator()
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}')
              );
            } else if (snapshot.hasData) {
              String  cardinalValues = "Latitude: ${snapshot.data!.latitude} Longitude: ${snapshot.data!.longitude}";
              return Center(
                child: Text(cardinalValues),
              );
            } else {
              return const Center(
                child: Text('No data available')
              );
            }
          },
        ),
      ],
    );
  }
}

// class _GetCurrentPosition extends Position {

// }