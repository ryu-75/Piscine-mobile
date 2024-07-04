import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app_v2_proj/widget/city_list.dart';

class SearchButton extends StatefulWidget {
  final ValueNotifier<String?> selectedCity;
  final TextEditingController controller;
  final ValueNotifier<List<String>> cityName;
  final ValueNotifier<bool?> currentPosition;
  final FocusNode? focusNode;
  final String providerError;

  const SearchButton({
    super.key,
    required this.controller,
    required this.selectedCity,
    required this.cityName,
    required this.currentPosition,
    required this.providerError,
    this.focusNode,
  });

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  late TextEditingController controller;
  late FocusNode focusNode;
  List<String> filteredSuggestions = [];
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    focusNode = widget.focusNode ?? FocusNode();

    controller.addListener(_onTextChanged);
    _checkConnectivity();
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      filteredSuggestions = widget.cityName.value
          .where((city) =>
              city.toLowerCase().startsWith(controller.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
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
            locationButton(),
          ],
        ),
        if (!isConnected)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No internet connection. Please check your connection and try again.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        cityList(),
      ],
    );
  }

  RotatedBox locationButton() {
    return RotatedBox(
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
    );
  }

  Stack searchButton(double screenWidth) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: ElevatedButton.icon(
            label: KeyboardListener(
              focusNode: focusNode,
              child: SizedBox(
                width: screenWidth * 0.4,
                child: textField(screenWidth),
              ),
            ),
            icon: const Icon(Icons.search),
            autofocus: false,
            onPressed: () {
              _updateSelectedCity();
            },
          ),
        ),
      ],
    );
  }

  void _updateSelectedCity() {
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please try again later.'),
        ),
      );
      return;
    }

    setState(() {
      String newValue = controller.text;
      if (newValue.isNotEmpty && widget.providerError.isNotEmpty) {
        widget.selectedCity.value = newValue;
        widget.cityName.value.clear();
        widget.cityName.value.add(widget.selectedCity.value!);
        controller.text = "";
      } else {
        newValue = "";
        widget.selectedCity.value = newValue;
        widget.cityName.value.clear();
        controller.text = "";
      }
    });
  }

  Visibility cityList() {
    return Visibility(
      visible: filteredSuggestions.isNotEmpty && controller.text.isNotEmpty,
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 50,
            child: Card(
              child: CityList(
                controller: controller,
                selectedCity: widget.selectedCity,
                cityName: widget.cityName,
                currentPosition: widget.currentPosition,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(double screenWidth) {
    return GestureDetector(
      child: TextField(
        onTap: () {
          if (widget.selectedCity.value == null) controller.text = "";
        },
        textInputAction: TextInputAction.search,
        controller: controller,
        style: TextStyle(
          color:
              controller.text == "Select a city" ? Colors.grey : Colors.black,
        ),
        onChanged: (String value) {
          setState(() {
            filteredSuggestions = widget.cityName.value
                .where((city) =>
                    city.toLowerCase().startsWith(value.toLowerCase()))
                .toList();
          });
        },
        onSubmitted: (String? text) {
          _updateSelectedCity();
        },
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: 'Select a city',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
