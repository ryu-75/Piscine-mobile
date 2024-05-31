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
import 'package:weather_app_v2_proj/widget/city_widget.dart';
import 'package:weather_app_v2_proj/widget/pop_up_validation.dart';

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
      routes: {
        '//': (context) => const MyHomePage(),
        '/today':(context) => const TodayWeatherScreenView(),
        '/weekly': (context) => const WeeklyWeatherScreenView(),
      },
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

  int selectedIndex = 0;
  String? selectedCity;
  List<String> cityName = [];
  bool  currentPosition = false;

  @override
  void  dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: appBarTop(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: <Widget>[
          CurrentlyWeatherScreenView(cityName: selectedCity, currentPosition: currentPosition),
          TodayWeatherScreenView(cityName: selectedCity, currentPosition: currentPosition),
          WeeklyWeatherScreenView(cityName: selectedCity, currentPosition: currentPosition),
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
      elevation: 4,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:30),
                child: searchButton(),
              ),
              Positioned(
                right: 0,
                child: PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  padding: const EdgeInsets.only(top: 10),
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String? value) {
                    setState(() {
                      currentPosition = false;
                      selectedCity = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return cityName.take(1).map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList();
                  },
                ),
              ),
            ],
          ),
          RotatedBox(
            quarterTurns: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCity = '';
                  currentPosition = true;
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
                  color: mainColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Search button
  ElevatedButton searchButton() {
    MediaQueryData  queryData = MediaQuery.of(context);
    
    double screenWidth = queryData.size.width;
    return ElevatedButton.icon(
      label: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (e) {
          if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.enter) {
            setState(() {
              String? newValue = myController.text;
              if (newValue.isNotEmpty) {
                selectedCity = newValue;
                if (cityName.isNotEmpty) cityName.clear();
                cityName.add(selectedCity!);
                myController.text = '';
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
      iconAlignment: IconAlignment.start,
      onPressed: () {
        setState(() {
          String? newValue = myController.text;
          if (newValue.isNotEmpty) {
            selectedCity = newValue;
            cityName.add(selectedCity!);
            myController.text = '';
            myController.clear();
          }
        });
      },                   
    );
  }

  // Text field
  TextField textField(double screenWidth) {
    return TextField(
      textInputAction: TextInputAction.search,
      controller: myController,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent), 
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent)
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

