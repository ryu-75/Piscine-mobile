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
            child: Text(
              'Error: ${snapshot.error}',
              textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.red,
                ),
            ),
          );
        } else if (snapshot.hasData) {
          String cardinalValues = "${snapshot.data!.latitude}, ${snapshot.data!.longitude}";
          return Center (
              child: Text(
                cardinalValues,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                ),
              ),
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