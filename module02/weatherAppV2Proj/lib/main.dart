import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_v2_proj/model/suggestion_model.dart';

import 'Screen/currently_weather_screen.dart';
import 'widget/city_list.dart';
import 'widget/search_button.dart';
import 'Screen/today_weather_screen.dart';
import 'Screen/weekly_weather_screen.dart';

// Variable colors
const Color mainColor = Color.fromARGB(220, 238, 238, 238);
void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => SuggestionModel(), child: const MyApp()),
  );
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
  final PageController _pageController = PageController();
  final FocusNode _focusNode = FocusNode();
  final bool showPopup = true;

  ValueNotifier<String> statusNotifier = ValueNotifier<String>("currently");

  int selectedIndex = 0;

  final ValueNotifier<String?> selectedCityNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<List<String>> cityNameNotifier =
      ValueNotifier<List<String>>([]);
  final ValueNotifier<bool> currentPositionNotifier =
      ValueNotifier<bool>(false);

  @override
  void dispose() {
    myController.dispose();
    selectedCityNotifier.dispose();
    cityNameNotifier.dispose();
    currentPositionNotifier.dispose();
    statusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredSuggestions =
        context.watch<SuggestionModel>().filteredSuggestion;
    print("$filteredSuggestions");
    // print("status: $status");
    return Scaffold(
      appBar: appBarTop(),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
                if (index == 0) {
                  statusNotifier.value = "currently";
                } else if (index == 1) {
                  statusNotifier.value = "today";
                } else {
                  statusNotifier.value = "weekly";
                }
              });
            },
            children: <Widget>[
              CurrentlyWeatherScreenView(
                  selectedCity: selectedCityNotifier,
                  selectedPosition: currentPositionNotifier,
                  status: statusNotifier,
                  filteredSuggestions:
                      Provider.of<SuggestionModel>(context).filteredSuggestion),
              TodayWeatherScreenView(
                  selectedCity: selectedCityNotifier,
                  selectedPosition: currentPositionNotifier,
                  status: statusNotifier,
                  filteredSuggestions:
                      Provider.of<SuggestionModel>(context).filteredSuggestion),
              WeeklyWeatherScreenView(
                  selectedCity: selectedCityNotifier,
                  selectedPosition: currentPositionNotifier,
                  status: statusNotifier,
                  filteredSuggestions:
                      Provider.of<SuggestionModel>(context).filteredSuggestion),
            ],
          ),
          CityList(
            controller: myController,
            selectedCity: selectedCityNotifier,
            cityName: cityNameNotifier,
            currentPosition: currentPositionNotifier,
            showPopup: true,
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
        BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'Weekly'),
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
