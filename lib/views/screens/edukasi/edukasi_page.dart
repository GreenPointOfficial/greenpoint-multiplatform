import 'package:flutter/material.dart';
import 'package:greenpoint/views/screens/edukasi/edukasi_1_page.dart';
import 'package:greenpoint/views/screens/edukasi/edukasi_2_page.dart';

class EdukasiPage extends StatefulWidget {
  const EdukasiPage({Key? key}) : super(key: key);

  @override
  _EdukasiPageState createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                Edukasi1Page(pageController: _pageController),
                Edukasi2Page(pageController: _pageController),
              ],
            ),
          ),
          // SmoothPageIndicator is removed since it's included in the pages
        ],
      ),
    );
  }
}
