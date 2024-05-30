import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
<<<<<<< HEAD
  final List<String> _recentSearches = [];

  int selectedIndex = 0;
  String cityName = "";
  String _lastSearch = '';
=======
  final PageController  _pageController = PageController();
  final FocusNode _focusNode = FocusNode();

  int selectedIndex = 0;
  String? selectedCity;
  List<String> cityName = [];
>>>>>>> 1c28c5c283d012b5d8e75ff7c89b6844ff50d417

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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
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
                CityWidget(city: selectedCity),
              ],
            ),
          ),
          TodayWeatherScreenView(cityName: selectedCity),
          WeeklyWeatherScreenView(cityName: selectedCity),
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
<<<<<<< HEAD
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
=======
          Stack(
            children: [
              searchButton(),
              Positioned(
                right: 0,
                child: PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  padding: const EdgeInsets.only(top: 10),
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (String? value) {
                    setState(() {
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
>>>>>>> 1c28c5c283d012b5d8e75ff7c89b6844ff50d417
              ),
            ],
          ),
          RotatedBox(
            quarterTurns: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCity = "Geological";
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

