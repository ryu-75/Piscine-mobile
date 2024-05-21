import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherApi extends StatefulWidget {
  const WeatherApi({super.key});
  
  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  String  data = '';
  String  apiUrl = "https://api.open-meteo.com/v1/forecast?hourly=temperature_2m";

  Future<void>  fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } on Exception catch (e) {
      setState(() {
        data = 'Error: $e';
      });
    }
  } 

  @override
  Widget  build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: fetchData,
          child: const Text('Fetch data'),
        ),
        const SizedBox(height: 20),
        Text(data),
      ],
    );
  }
}
