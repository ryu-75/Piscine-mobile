import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:weather_app_proj/widget/city_widget.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'Screen/today_weather_screen.dart';
import 'Screen/weekly_weather_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';

// Variable colors
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
  final List<String> _recentSearches = [];

  int selectedIndex = 0;
  String cityName = "";
  String _lastSearch = '';

  // FocusNode searchFocusNode = FocusNode();
  // FocusNode textFieldFocusNode = FocusNode();
  
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
              Flex(
                direction: Axis.horizontal,
                children: [
                  TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                      labelText: 'Enter text',
                    ),
                  ),
                  // DropdownButton<String>(
                  //   hint: Text('Last Search: $_lastSearch'),
                  //   items: _recentSearches.map((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? newValue) {
                  //     if (newValue != null) {
                  //       setState(() {
                  //         _lastSearch = newValue;
                  //         myController.text = newValue;
                  //       });
                  //     }
                  //   },
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        String searchText = myController.text;
                        _lastSearch = searchText;
                        if (!_recentSearches.contains(searchText)) {
                          _recentSearches.insert(0, searchText);
                        }
                      });
                    },
                    child: const Text('Search'),
                  ),
                  // RotatedBox(
                  //   quarterTurns: 1,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         cityName = myController.text;
                  //       });
                  //     },
                  //     child: Container(
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.grey.withOpacity(0.5),
                  //       ),
                  //       child: const Icon(
                  //         Icons.navigation_outlined,
                  //         size: 30,
                  //         color: mainColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],    
              ),
            ],
          ),
        ],
      ),
    );
  }
}

