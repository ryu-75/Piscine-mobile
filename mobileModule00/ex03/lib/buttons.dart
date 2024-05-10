import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  // Init variables
  final Color? buttonColor;
  final Color? textColor;
  final String? buttonText;
  final VoidCallback? buttontapped;

  // Constructor
  MyButton({this.textColor, this.buttonColor, this.buttonText, this.buttontapped});

  @override
  Widget build(BuildContext context) {
    Size    screenSize = MediaQuery.of(context).size;
    double  screenHeight = screenSize.height;
    double  screenWidth = screenSize.width;
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.1,
              maxWidth: screenWidth * 0.1,
            ),
            color: buttonColor,
            child: Center(
              child: Text(
                buttonText!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}