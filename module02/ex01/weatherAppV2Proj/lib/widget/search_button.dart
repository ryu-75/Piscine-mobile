import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2_proj/widget/city_list.dart';

class SearchButton extends StatefulWidget {
  final ValueNotifier<String?>  selectedCity;
  final TextEditingController controller;
  final ValueNotifier<List<String>> cityName;
  final ValueNotifier<bool?> currentPosition;
  final FocusNode? focusNode;
  final bool  showPopup;

  const SearchButton({
    super.key,
    required this.controller,
    required this.selectedCity,
    required this.cityName,
    required this.currentPosition,
    required this.showPopup,
    this.focusNode
  });

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  late TextEditingController controller;
  late FocusNode focusNode;
  List<String>  filteredSuggestions = [];
  bool  showPopup = false;
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

  void  _onTextChanged() {
    setState(() {
      showPopup = controller.text.isNotEmpty;
    });
  }

  void  onSearchTextChanged() {
    String  searchText = controller.text;
    setState(() {
      filteredSuggestions = widget.cityName.value
        .where((city) => city.toLowerCase().startsWith(controller.text.toLowerCase()))
        .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            searchButton(screenWidth),
            RotatedBox(
              quarterTurns: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selectedCity.value = '';
                    widget.currentPosition.value = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: const Icon(
                    Icons.navigation_outlined,
                    size: 30,
                    color: Color.fromARGB(220, 238, 238, 238),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Stack searchButton(double screenWidth) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: ElevatedButton.icon(
            label: KeyboardListener(
              focusNode: focusNode,
              onKeyEvent: (e) {
                if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.enter) {
                  setState(() {
                    String newValue = controller.text;
                    if (newValue.isNotEmpty) {
                      widget.selectedCity.value = newValue;
                      widget.cityName.value.clear();
                      widget.cityName.value.add(widget.selectedCity.value!);
                      controller.text = '';
                    }
                  });
                }
              },
              child: SizedBox(
                width: screenWidth * 0.4,
                child: textField(screenWidth),
              ),
            ),
            icon: const Icon(Icons.search),
            autofocus: false,
            onPressed: () {
              setState(() {
                String newValue = controller.text;
                if (newValue.isNotEmpty) {
                  widget.selectedCity.value = newValue;
                  widget.cityName.value.add(widget.selectedCity.value!);
                  controller.text = '';
                  controller.clear();
                }
              });
            },
          ),
        ),  
      ],
    );
  }

  Visibility cityList() {
    return Visibility(
        visible: widget.showPopup && filteredSuggestions.isNotEmpty && controller.text.isNotEmpty,
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 50,
            child: Card(
              child: ListView.builder(
                itemCount: filteredSuggestions.length,
                itemBuilder: (BuildContext context, int index) {
                  String suggestion = filteredSuggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      setState(() {
                        widget.currentPosition.value = false;
                        widget.selectedCity.value = suggestion;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Text field
  TextField textField(double screenWidth) {
    return TextField(
      textInputAction: TextInputAction.search,
      controller: controller,
      onChanged: (value) {
        setState(() {
          filteredSuggestions = widget.cityName.value
              .where((city) => city.toLowerCase().startsWith(value.toLowerCase()))
              .toList();
        });
      },
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        hintText: 'Select a city',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
