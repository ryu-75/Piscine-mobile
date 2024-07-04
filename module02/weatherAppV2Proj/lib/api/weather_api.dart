import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GetCardinal extends StatelessWidget {
  const GetCardinal({super.key});

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

  Widget buildCityNameWidget(Position position) {
    return FutureBuilder<String>(
      future: fetchCityName(position.latitude, position.longitude),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Text(
            'The service connection is lost, please check your internet connection or try again later',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          );
        } else {
          return Text(
            "${snapshot.data!}\n${position.latitude}, ${position.longitude}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }

  Future<Position> determinePosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception("Failed to get location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Position>(
        future: determinePosition(),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Text(
              'The service connection is lost, please check your internet connection or try again later',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            );
          } else {
            return buildCityNameWidget(snapshot.data!);
          }
        },
      ),
    );
  }
}
