import 'package:flutter/material.dart';

class CityWidget extends StatelessWidget {
  final String?  city;

  const CityWidget ({
    this.city,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      city ?? "",
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}