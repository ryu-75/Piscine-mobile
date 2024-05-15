import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:weather_app_proj/widget/city_widget.dart';

import 'Screen/today_weather_screen.dart';
import 'Screen/weekly_weather_screen.dart';

// Variable colors
const Color mainColor = Color.fromARGB(220, 238, 238, 238);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  int selectedIndex = 0;
  String cityName = "";

  @override
  void  dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTop(),
      body: IndexedStack(
        index: selectedIndex,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Currently",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CityWidget(city: cityName),
              ],
            ),
          ),
          TodayWeatherScreenView(cityName: cityName),
          WeeklyWeatherScreenView(cityName: cityName),
        ],
      ),
      bottomNavigationBar: bottomNavigation(),
    );
  }

  // Bottom Navigation
  BottomNavigationBar bottomNavigation() {
    return BottomNavigationBar(
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
      currentIndex: selectedIndex,
      onTap: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      unselectedItemColor: mainColor,
    );
  }

  // Top Bar 
  AppBar appBarTop() {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      shadowColor: Colors.blueGrey,
      elevation: 4,
      title: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    controller: myController,
                    showCursor: false,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Search location...',
                      labelStyle: TextStyle(
                        color: mainColor,
                        fontSize: 14,
                      ),
                      constraints: BoxConstraints(
                        maxHeight: 50,
                        maxWidth: 200,
                      ),
                    ),
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      cityName = myController.text;
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
        ],
      ),
    );
  }
}

