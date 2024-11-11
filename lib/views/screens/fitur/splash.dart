import 'dart:async';

import 'package:flutter/material.dart';
import 'package:greenpoint/views/screens/fitur/edukasi_page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => EdukasiPage())));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Hero(
              tag: "logo_edukasi1",
              child: Image.asset(
                "lib/assets/imgs/logo.gif",
                width: 400,
                height: 400,
              ),
            ),
          )),
    );
  }
}
