import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GetCardinal {
  static const String apiKey = "7878e44e23e6ec0e62860e109fb8fb76";
  static const String apiUrl = "http://api.openweathermap.org/geo/1.0/reverse?";

  Future<String> fetchCityName(double latitude, double longitude) async {
    final completeUrl = "${apiUrl}lat=$latitude&lon=$longitude&appid=$apiKey";
    final response = await http.get(Uri.parse(completeUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data[0]['local_names']['fr'];
    } else {
      return "The service connection is lost, please check your internet connection or try again later";
    }
  }

  FutureBuilder<String> buildCityNameWidget(Position position) {
    return FutureBuilder<String>(
      future: fetchCityName(position.latitude, position.longitude),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
          return Center(
            child: Text(
              "${snapshot.data!}\n${position.latitude}, ${position.longitude}",
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
  }

  Future<Position> determinePosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception("Failed to get location: $e");
    }
    return position;
  }

  Widget getCardinal() {
    return FutureBuilder<Position>(
      future: determinePosition(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return buildCityNameWidget(snapshot.data!);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
