import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'buttons.dart';
// import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ex03',
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
  String value = "";
  String result = "0";
  String  finalResult = '0';
  bool  isDot = false;

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
                      margin: EdgeInsets.only(bottom: 10, right: 20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, right: 20),
                      alignment: Alignment.centerRight,  
                      child: Text(
                        result,
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
          setState(() {
            calculate(btnTxt);
          });
        },
        buttonText: btnTxt,
        buttonColor: btnColor,
        textColor: txtColor,
      ),
    );
  }

  bool  isOperator(String value) {
    return ['+', '-', '/', 'x', '.'].contains(value);
  }

  bool  isNumeric(String value) {
    return int.tryParse(value) != null || value == '.';
  }

  void  calculate(String btnTxt) {
    if (btnTxt != '=' && btnTxt != 'AC' && btnTxt != 'C') {
      if (isNumeric(btnTxt) || isOperator(btnTxt)) {
        if (finalResult.isEmpty && result.isNotEmpty && value.isEmpty && isOperator(btnTxt) && btnTxt != '.') {
          value += result;
          result = '';
        }
        if ((value.isEmpty && (btnTxt == '+' || btnTxt == 'x' || btnTxt == '/' || btnTxt == '.' || btnTxt == "00" || btnTxt == '0')) || 
          (value.isNotEmpty && value[value.length - 1] == '.' && isOperator(btnTxt)) || 
            (value.isNotEmpty && value[value.length - 1] == '-' && (btnTxt == 'x' || btnTxt == '/' || btnTxt == '-' || btnTxt == '.')) ||
              (value.isNotEmpty && (value[value.length - 1] == '/' || value[value.length - 1] == '+' || value[value.length - 1] == 'x') && btnTxt == '.') ||
                (value.isNotEmpty && value[value.length - 1] == '0' && isOperator(value[value.length - 2]) && !isOperator(btnTxt) && btnTxt == '.') ||
                  (value.isNotEmpty && isOperator(value[value.length - 1]) && btnTxt == "00")) return ;
        if (value.isEmpty || value.isEmpty && btnTxt == '-') {
          value = btnTxt;
        } else if (value.isNotEmpty && (isNumeric(btnTxt) || isOperator(btnTxt))) {
          if ((isNumeric(value[value.length - 1]) && isNumeric(btnTxt)) || 
            (isNumeric(value[value.length - 1]) && isOperator(btnTxt)) || 
              (isOperator(value[value.length - 1]) && isNumeric(btnTxt))) {
                value += btnTxt;
          }
          else if (value[value.length - 1] == '+' && btnTxt == '-') {
            value += btnTxt;
          }
        }
      } else {
        throw ExceptionInput("There is an issue in your input");
      }
    } else if (btnTxt == 'AC') {
      value = '';
      result = '0';
    } else if (btnTxt == 'C') {
      if (value.isNotEmpty) {
        value = value.substring(0, value.length - 1);
      }
    } else if (btnTxt == '=' && value.length > 1 && !isOperator(value[value.length - 1]) && (value.indexOf("+") > 0 || value.indexOf("/") > 0 || value.indexOf("x") > 0 || value.indexOf("-") > 0)) {
      finalResult = value;
      finalResult = value.replaceAll('x', '*');

      Parser  p = Parser();
      Expression exp = p.parse(finalResult);
      ContextModel  cm = ContextModel();
      double  eval = exp.evaluate(EvaluationType.REAL, cm);
      value = '';
      finalResult = '';
      if (eval is int) {
        result = eval.toString();
      } else {
        String  roundedValue = eval.toStringAsFixed(1);
        result = roundedValue.toString();
      }
    }
  }
}

class ExceptionInput implements Exception {
  final String  message;

  ExceptionInput(this.message);
}