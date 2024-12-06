import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/screens/fitur/beranda.dart';
import 'package:greenpoint/views/screens/fitur/lokasi.dart';
import 'package:greenpoint/views/screens/fitur/profile.dart';

class NavBottom extends StatefulWidget {
  const NavBottom({super.key});

  @override
  _NavBottomState createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  int currentScreen = 0;
  final screens = [Beranda(), LokasiPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GreenPointColor.primary,
      body: screens[currentScreen],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Colors.grey.shade50,
        animationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 200),
        backgroundColor: GreenPointColor.secondary,
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
        },
        items: [
          Icon(Icons.home, color: GreenPointColor.secondary),
          Icon(Icons.location_on, color: GreenPointColor.secondary),
          Icon(Icons.person, color: GreenPointColor.secondary),
        ],
      ),
    );
  }
}