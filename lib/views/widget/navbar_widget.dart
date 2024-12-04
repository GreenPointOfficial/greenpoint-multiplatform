import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/screens/fitur/beranda.dart';
import 'package:greenpoint/views/screens/fitur/lokasi.dart';

class navBottom extends StatelessWidget {
  const navBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentScreen = 0;
  //
  final Screens = [Beranda(), LokasiPage()];

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GreenPointColor.primary,
      body: Screens[currentScreen],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
          color: Colors.grey.shade50,
          // buttonBackgroundColor: Colors.amber,
          animationCurve: Curves.easeIn,
          animationDuration: Duration(milliseconds: 200),
          backgroundColor: GreenPointColor.secondary,
          onTap: (index) {
            print(index);
            setState(() {
              currentScreen = index;
            });
          },
          items: [
            Container(
              child: Icon(
                Icons.home,
                color: GreenPointColor.secondary,
              ),
            ),
            Icon(
              Icons.location_on,
              color: GreenPointColor.secondary,
            ),
            Icon(
              Icons.person,
              color: GreenPointColor.secondary,
            )
          ]),
    );
  }
}