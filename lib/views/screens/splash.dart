import 'dart:async';

import 'package:flutter/material.dart';
import 'package:greenpoint/views/screens/edukasi/edukasi.dart';

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
            builder: (BuildContext context) =>  EdukasiPage())));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            
            child: Hero(
              tag: "logo_edukasi1",
              child: Image.asset(
                
                "lib/assets/imgs/logo.png",
                width: 355,
                height: 372,
              ),
            ),
          )),
    );
  }
}
