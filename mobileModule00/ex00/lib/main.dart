import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ex00',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget  build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(228, 108, 204, 0.8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BigCard(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  print("Button pressed");
                },
                child: Text('Click me!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(127, 127, 127, 0.9),
            blurRadius: 20,
          ),
        ],
      ),
      child: Card(
        color: theme.primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child : Text(
            "Simple text!",
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}