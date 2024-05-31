import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2_proj/widget/city_widget.dart';

class ApiService extends StatefulWidget{
  final String?  instanceCityName;
  const ApiService({this.instanceCityName, super.key});

  @override
  State<ApiService> createState() => _ApiServiceState();
}

class _ApiServiceState extends State<ApiService> {
  String  apiKey = "&appid=7878e44e23e6ec0e62860e109fb8fb76";
  String  apiUrl = "http://api.openweathermap.org/geo/1.0/direct?q=";
  String  limit = "&limit=5";
  String? cityName;

  @override
  void  initState() {
    super.initState();
    cityName = widget.instanceCityName;
  }

  String  get url => apiUrl + cityName! + limit + apiKey;
  Future<http.Response> fetchWeatherData() async {
    final completeUrl = url;
    print(url);
    return await http.get(Uri.parse(completeUrl));
  }

  @override
  Widget build(BuildContext context) {
    print("$cityName");
    return Center(
      child: FutureBuilder<List<dynamic>>(
        future: fetchAndDecodeWeatherData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            String  data = "${snapshot.data![0]['lon']}, ${snapshot.data![0]['lat']}";
            return Center(
              child: Text(data),
            );
          } else {
            return const Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>>  fetchAndDecodeWeatherData() async {
    final response = await fetchWeatherData();

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception("Data cannot fetch");
    }
  }
}

/**
  Goals:
    * Add a drop down menu to display until 5 arguments about the content write in the text field.
      Ex: Paris, Ile-de-France
  We can currently fetch the right position from the text field 
**/