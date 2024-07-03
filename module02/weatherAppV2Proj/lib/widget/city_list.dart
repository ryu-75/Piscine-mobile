import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:weather_app_v2_proj/model/suggestion_model.dart';

class CityList extends StatefulWidget {
  final ValueNotifier<String?> selectedCity;
  final TextEditingController controller;
  final ValueNotifier<List<String>> cityName;
  final ValueNotifier<bool?> currentPosition;
  final FocusNode? focusNode;
  final String? instanceCityName;

  const CityList({
    super.key,
    required this.controller,
    required this.selectedCity,
    required this.cityName,
    required this.currentPosition,
    this.instanceCityName,
    this.focusNode,
  });

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  late TextEditingController controller;
  late FocusNode focusNode;

  String apiKey = "&appid=7878e44e23e6ec0e62860e109fb8fb76";
  String apiUrl = "http://api.openweathermap.org/geo/1.0/direct?q=";
  String limit = "&limit=5";
  String? cityName;
  bool showPopup = false;

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
        showPopup = true;
        fetchWeatherData(controller.text);
      } else {
        Provider.of<SuggestionModel>(context, listen: false)
            .updateSuggestions([]);
        showPopup = false;
      }
    });
  }

  Future<void> fetchWeatherData(String query) async {
    final completeUrl = "$apiUrl$query$limit$apiKey";
    try {
      final response = await http.get(Uri.parse(completeUrl));
      final List<dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data.isEmpty) {
          if (mounted) {
            Provider.of<SuggestionModel>(context, listen: false)
                .updateSuggestions([]);
            Provider.of<SuggestionModel>(context, listen: false).setErrorMessage(
                "Could not find any result for the supplied address or coordinates.");
          }
        } else {
          if (mounted) {
            Provider.of<SuggestionModel>(context, listen: false)
                .updateSuggestions(data
                    .map((item) => {
                          "name": item["name"],
                          "country": item["country"],
                          "state": item["state"],
                          "lon": item["lon"],
                          "lat": item["lat"]
                        })
                    .toList());
            Provider.of<SuggestionModel>(context, listen: false)
                .setErrorMessage("");
          }
        }
      } else {
        if (mounted) {
          Provider.of<SuggestionModel>(context, listen: false)
              .setErrorMessage("Failed to fetch data from API.");
        }
      }
    } catch (e) {
      if (mounted) {
        Provider.of<SuggestionModel>(context, listen: false)
            .setErrorMessage("An error occurred: ${e.toString()}");
      }
      if (mounted) {
        Provider.of<SuggestionModel>(context, listen: false)
            .updateSuggestions([]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maxDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    List<dynamic> filteredSuggestions =
        Provider.of<SuggestionModel>(context).filteredSuggestion;
    String errorMessage = Provider.of<SuggestionModel>(context).errorMessage;
    if (errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            showPopup = false;
          });
        },
        child: Visibility(
          visible: showPopup,
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
                    suggestion['state'] ?? '',
                    suggestion['country']
                  ];
                  return ListTile(
                    title: Text(
                      suggestion['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(suggestionParts[0].isNotEmpty
                        ? suggestionParts.join(', ')
                        : suggestionParts[1]),
                    onTap: () {
                      _updateCitySearched(suggestion, suggestionParts, context);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  void _updateCitySearched(
      suggestion, List<String> suggestionParts, BuildContext context) {
    return setState(() {
      FocusManager.instance.primaryFocus?.unfocus();
      widget.currentPosition.value = false;
      widget.selectedCity.value =
          suggestion['name'] + ', ' + suggestionParts.join(', ');
      controller.text = suggestion['name'] + ', ' + suggestionParts.join(', ');
      Provider.of<SuggestionModel>(context, listen: false)
          .updateSuggestions([]);
      showPopup = false;
    });
  }
}
