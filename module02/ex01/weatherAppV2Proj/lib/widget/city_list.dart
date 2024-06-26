import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CityList extends StatefulWidget {
  final ValueNotifier<String?> selectedCity;
  final TextEditingController controller;
  final ValueNotifier<List<String>> cityName;
  final ValueNotifier<bool?> currentPosition;
  final FocusNode? focusNode;
  final bool showPopup;
  final String? instanceCityName;

  const CityList(
      {super.key,
      required this.controller,
      required this.selectedCity,
      required this.cityName,
      required this.currentPosition,
      required this.showPopup,
      this.instanceCityName,
      this.focusNode});

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  late TextEditingController controller;
  late FocusNode focusNode;

  List<dynamic> filteredSuggestions = [];

  bool showPopup = false;
  String apiKey = "&appid=7878e44e23e6ec0e62860e109fb8fb76";
  String apiUrl = "http://api.openweathermap.org/geo/1.0/direct?q=";
  String limit = "&limit=5";
  String? cityName;
  String get url => apiUrl + cityName! + limit + apiKey;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    focusNode = widget.focusNode ?? FocusNode();
    cityName = widget.instanceCityName;

    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      if (controller.text.isNotEmpty) {
        fetchWeatherData(controller.text);
      } else {
        setState(() {
          filteredSuggestions = [];
        });
      }
    });
  }

  Future<void> fetchWeatherData(String query) async {
    final completeUrl = apiUrl + query + limit + apiKey;
    try {
      final response = await http.get(Uri.parse(completeUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          filteredSuggestions = data
              .map((item) => {
                    "name": item["name"],
                    "country": item["country"],
                    "state": item["state"],
                  })
              .toList();
        });
      } else {
        throw Exception("Data cannot fetch");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        filteredSuggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Visibility(
      visible: widget.showPopup && controller.text.isNotEmpty,
      child: SizedBox(
        height: maxDimension,
        width: maxDimension,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ListView.separated(
            itemCount: filteredSuggestions.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final suggestion = filteredSuggestions[index];
              final List<String> suggestionParts = [
                suggestion['name'],
                suggestion['state'] ?? '',
                suggestion['country']
              ];
              return ListTile(
                title: Text(suggestionParts.join(', ')),
                onTap: () {
                  setState(() {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.currentPosition.value = false;
                    widget.selectedCity.value = suggestionParts.join(', ');
                    controller.text = suggestionParts.join(', ');
                    filteredSuggestions = [];
                    showPopup = false;
                    controller.text = "";
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// Pop up display correctly but it's still empty
// We should to retrieve each element (city, country, state from API)
// And showing all occurence from API data 