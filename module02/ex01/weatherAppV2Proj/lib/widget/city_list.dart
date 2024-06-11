import 'package:flutter/material.dart';

class CityList extends StatefulWidget {
  final ValueNotifier<String?> selectedCity;
  final TextEditingController controller;
  final ValueNotifier<List<String>> cityName;
  final ValueNotifier<bool?> currentPosition;
  final FocusNode? focusNode;
  final bool showPopup;

  const CityList(
      {super.key,
      required this.controller,
      required this.selectedCity,
      required this.cityName,
      required this.currentPosition,
      required this.showPopup,
      this.focusNode});

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  late TextEditingController controller;
  late FocusNode focusNode;
  List<String> filteredSuggestions = [];
  bool showPopup = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    focusNode = widget.focusNode ?? FocusNode();

    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void onSearchTextChanged() {
    setState(() {
      filteredSuggestions = widget.cityName.value
          .where((city) =>
              city.toLowerCase().startsWith(controller.text.toLowerCase()))
          .toList();
    });
  }

  void _onTextChanged() {
    setState(() {
      if (widget.showPopup) {
        onSearchTextChanged();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (filteredSuggestions.isEmpty) {
      print("Is empty");
    } else {
      print("Is not empty");
    }
    return Visibility(
      visible: widget.showPopup && controller.text.isNotEmpty,
      child: Positioned(
        top: 0,
        left: 50,
        child: SizedBox(
          height: 50,
          width: 150,
          child: Card(
            child: ListView.builder(
              itemCount: filteredSuggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredSuggestions[index]),
                  onTap: () {
                    setState(() {
                      widget.currentPosition.value = false;
                      widget.selectedCity.value = filteredSuggestions[index];
                    });
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

// Pop up display correctly but it's still empty
// We should to retrieve each element (city, country, state from API)
// And showing all occurence from API data 