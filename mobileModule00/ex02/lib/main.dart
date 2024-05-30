import 'package:flutter/material.dart';
import 'buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ex02',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(
        title: 'Calculator'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        elevation: 5,
        shadowColor: Colors.deepPurple.shade100,
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "0",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,  
                      child: Text(
                        "0",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            buttonRow('AC', Colors.deepPurple.shade400, Colors.red),
                            buttonRow('.', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('C', Colors.deepPurple.shade400, Colors.red),
                            buttonRow('/', Colors.deepPurple.shade400, Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            buttonRow('7', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('8', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('9', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('x', Colors.deepPurple.shade400, Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            buttonRow('4', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('5', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('6', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('-', Colors.deepPurple.shade400, Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            buttonRow('1', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('2', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('3', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('+', Colors.deepPurple.shade400, Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            buttonRow('00',Colors.deepPurple.shade400, Colors.black),
                            buttonRow('0', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('', Colors.deepPurple.shade400, Colors.black),
                            buttonRow('=', Colors.deepPurple.shade400, Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },  
      ),
    );
  } 

  Widget buttonRow(String btnTxt, Color btnColor, Color txtColor) {
    return Expanded(
      child: MyButton(
        buttontapped: () {
          if (btnTxt == '') return ;
          print('button pressed: $btnTxt');
        },
        buttonText: btnTxt,
        buttonColor: btnColor,
        textColor: txtColor,
      ),
    );
  }
}
