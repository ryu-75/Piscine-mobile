import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyWordState(),
      child: MaterialApp(
        title: 'ex01',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade300),
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyWordState extends ChangeNotifier {
  var currentWord = "Simple text!";

  String changeWord() {
    var newWord = "Hello world!";

    currentWord = currentWord != newWord ? newWord : "Simple text!";
    notifyListeners();
    return currentWord;
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget  build(BuildContext context) {
    var appState = context.watch<MyWordState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(125, 0, 100, 0.8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BigCard(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  appState.changeWord();
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
    var appState = context.watch<MyWordState>();
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
            appState.currentWord,
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