import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  child: TextField(
                    cursorColor: Colors.white,
                    showCursor: false,
                    autofocus: false,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      icon: Icon(
                        color: Colors.white,
                        Icons.search,
                      ),
                      labelText: 'Search a location',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      constraints: BoxConstraints(
                        maxHeight: 40,
                        maxWidth: 200,
                      ),
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: IconButton(
                    iconSize: 30,
                    splashRadius: 250,
                    icon: Icon(
                      color: Colors.white,
                      Icons.navigation_outlined,
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.amber,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.sunny),
            icon: Icon(
              Icons.wb_sunny_outlined,
            ),
            label: 'Currently'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.today,
            ),
            label: 'Today'
          ),
          NavigationDestination(
            icon: Icon(
              Icons.calendar_month,
            ),
            label: 'Weekly'
          ),
        ],
      ),
    );
  }
}

