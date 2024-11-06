import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';

class InputWidget extends StatefulWidget {
  final Color? fillColor; 
  final Color? textColor; 
  final Color? hintTextColor; 
  final String hintText; 
  final IconData? icon; 
  final bool isPassword; 
  final TextEditingController? controller; 

  const InputWidget({
    Key? key,
    this.fillColor,
    this.textColor,
    this.hintTextColor,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.controller,
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: widget.fillColor ?? GreenPointColor.abu,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // Offset of shadow
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        style: TextStyle(
          color: widget.textColor ?? Colors.black,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintTextColor ?? Colors.grey,
          ),
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: widget.textColor ?? Colors.grey)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: widget.textColor ?? Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none, // Removes border
          ),
        ),
      ),
    );
  }
}
