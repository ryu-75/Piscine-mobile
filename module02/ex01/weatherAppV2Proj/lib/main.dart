import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:weather_app_v2_proj/Screen/currently_weather_screen.dart';
import 'package:weather_app_v2_proj/api/api_service.dart';
import 'package:weather_app_v2_proj/api/weather_api.dart';
import 'package:weather_app_v2_proj/utils/geolocation.dart';
import 'package:weather_app_v2_proj/widget/city_list.dart';
import 'package:weather_app_v2_proj/widget/city_widget.dart';
import 'package:weather_app_v2_proj/widget/pop_up_validation.dart';
import 'package:weather_app_v2_proj/widget/search_button.dart';

import 'Screen/today_weather_screen.dart';
import 'Screen/weekly_weather_screen.dart';

// Variable colors
const Color mainColor = Color.fromARGB(220, 238, 238, 238);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Logger logger = Logger();
  final myController = TextEditingController();
  final PageController  _pageController = PageController();
  final FocusNode _focusNode = FocusNode();
  final bool  showPopup = true;

  int selectedIndex = 0;
  final ValueNotifier<String?>  selectedCityNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<List<String>>  cityNameNotifier = ValueNotifier<List<String>>([]);
  final ValueNotifier<bool>  currentPositionNotifier = ValueNotifier<bool>(false);

  @override
  void  dispose() {
    myController.dispose();
    selectedCityNotifier.dispose();
    cityNameNotifier.dispose();
    currentPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: appBarTop(),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            children: <Widget>[
              CurrentlyWeatherScreenView(
                selectedCity: selectedCityNotifier, 
                selectedPosition: currentPositionNotifier
              ),
              TodayWeatherScreenView(
                selectedCity: selectedCityNotifier, 
                selectedPosition: currentPositionNotifier
              ),
              WeeklyWeatherScreenView(
                selectedCity: selectedCityNotifier, 
                selectedPosition: currentPositionNotifier
              ),
            ],
          ),
          CityList(
            controller: myController, 
            selectedCity: selectedCityNotifier, 
            cityName: cityNameNotifier, 
            currentPosition: currentPositionNotifier, 
            showPopup: true
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigation(),
    );
  }

  // Bottom Navigation
  BottomNavigationBar bottomNavigation() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
        setState(() {
          selectedIndex = index;
        });
      },
      backgroundColor: Colors.blueGrey,
      selectedItemColor: Colors.amber,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.sunny),
          label: 'Currently',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: 'Today'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Weekly'
        ),
      ],
      unselectedItemColor: mainColor,
    );
  }

  // Top Bar 
  AppBar appBarTop() {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      shadowColor: Colors.blueGrey,
      elevation: 2,
      title: SearchButton(
        controller: myController, 
        selectedCity: selectedCityNotifier,
        cityName: cityNameNotifier,
        currentPosition: currentPositionNotifier, 
        focusNode: _focusNode,
        showPopup: true,
      ),
    );
  }
}

