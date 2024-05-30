import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_v2_proj/utils/geolocation.dart';

class GetCardinal {
  FutureBuilder<Position> getCardinal() {
    return FutureBuilder(
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
          return Center (
              child: Text(cardinalValues),
          );
        } else {
          return const Center(
            child: Text('No data available')
          );
        }
      },
    );
  }
}