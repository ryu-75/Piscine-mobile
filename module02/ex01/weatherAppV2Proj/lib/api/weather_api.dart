import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_v2_proj/utils/geolocation.dart';
import 'package:http/http.dart' as http;

class GetCardinal {
  String apiKey = "7878e44e23e6ec0e62860e109fb8fb76";
  String apiUrl = "http://api.openweathermap.org/geo/1.0/reverse?";
  String cityname = "";

  Future<String> fetchCityName(String longitude, String latitude) async {
    final completeUrl = "${apiUrl}lat=$latitude&lon=$longitude&appid=$apiKey";
    try {
      final response = await http.get(Uri.parse(completeUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return (data[0]['local_names']['fr']);
      } else {
        return "City is not found";
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Data cannot be fetch.");
    }
  }

  FutureBuilder<Position> getCardinal() {
    return FutureBuilder(
      future: determinePosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          String longitude = "${snapshot.data!.longitude}";
          String latitude = "${snapshot.data!.latitude}";
          return FutureBuilder<String>(
            future: fetchCityName(longitude, latitude),
            builder:
                (BuildContext context, AsyncSnapshot<String> citySnapshot) {
              if (citySnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (citySnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${citySnapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                );
              } else if (citySnapshot.hasData) {
                return Center(
                  child: Text(
                    "${citySnapshot.data!}\n$latitude, $longitude",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
