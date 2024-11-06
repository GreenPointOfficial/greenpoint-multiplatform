import 'package:flutter/material.dart';
import 'package:greenpoint/views/screens/splash.dart';

void main() {
  runApp(GreenPoint());
}

class GreenPoint extends StatelessWidget {
   GreenPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));
  }
}
