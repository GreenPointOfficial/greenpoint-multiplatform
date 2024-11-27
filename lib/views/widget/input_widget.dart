import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';

class InputWidget extends StatefulWidget {
  final Color? fillColor; 
  final Color? textColor; 
  final Color? hintTextColor; 
  final String hintText; 
  final IconData? icon; 
  final bool isPassword; 
  final TextEditingController? controller; 
  final String? errorText;

  const InputWidget({
    Key? key,
    this.fillColor,
    this.textColor,
    this.hintTextColor,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.errorText,

  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtils.screenWidth(context);
    double screenHeight = ScreenUtils.screenHeight(context);

    double iconSize = screenWidth * 0.06; // Adjust icon size based on screen width
    double padding = screenWidth * 0.05; // Adjust padding based on screen width
    double fontSize = screenWidth * 0.04; // Adjust font size based on screen width
    double hintFontSize = fontSize * 0.9; // Slightly smaller font size for hint text
    double inputWidth = screenWidth * 0.8; // Adjust width to be 80% of the screen width

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01), // Vertical margin based on screen height
      width: inputWidth, // Set responsive width for the input
      decoration: BoxDecoration(
        color: widget.fillColor ?? GreenPointColor.abu,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // Offset of shadow
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        style: TextStyle(
          color: widget.textColor ?? Colors.black,
          fontSize: fontSize, // Responsive font size
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintTextColor ?? Colors.grey,
            fontSize: hintFontSize, // Responsive hint text font size
          ),
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: widget.textColor ?? Colors.grey, size: iconSize)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: widget.textColor ?? Colors.grey,
                    size: iconSize, // Responsive icon size
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none, // Removes border
          ),
        ),
      ),
    );
  }
}
