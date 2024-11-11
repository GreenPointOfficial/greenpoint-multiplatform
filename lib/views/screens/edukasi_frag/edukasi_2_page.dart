import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/views/screens/auth/masuk_page.dart';
import 'package:greenpoint/views/widget/welcome_widget.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Edukasi2Page extends StatelessWidget {
  final PageController pageController;

  const Edukasi2Page({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using ScreenUtils
    final double screenWidth = ScreenUtils.screenWidth(context);
    final double screenHeight = ScreenUtils.screenHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Hero(
              tag: 'judul',
              child: JudulWidget(size: 24),
            ),
            SizedBox(height: screenHeight * 0.02),
            Hero(
              tag: 'logo_edukasi1',
              child: Image.asset(
                "lib/assets/imgs/logo_edukasi2.png",
                width: screenWidth * 0.6, 
                height: screenHeight * 0.3,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Additional spacing
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Text(
                "poin yang bisa dicairkan langsung ke dompet digital",
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: screenWidth * 0.03, // Adjust font size responsively
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            SmoothPageIndicator(
              controller: pageController,
              count: 2,
              effect: ScaleEffect(
                spacing: screenWidth * 0.02, radius: 100.0,
                dotWidth: screenWidth * 0.03, // Responsive dot width
                dotHeight: screenWidth * 0.03, // Responsive dot height
                paintStyle: PaintingStyle.fill,
                strokeWidth: 1.5,
                dotColor: Colors.grey,
                activeDotColor: GreenPointColor.abu,
              ),
            ),
            SizedBox(
                height: screenHeight * 0.03),
            TombolWidget(
              warna: GreenPointColor.secondary,
              warnaText: Colors.white,
              text: "Masuk",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MasukPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
