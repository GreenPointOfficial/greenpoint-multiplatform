import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/screens/auth/masuk.dart';
import 'package:greenpoint/views/widget/judul_widget.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Edukasi2Page extends StatelessWidget {
  final PageController pageController;

  const Edukasi2Page({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Hero(
            tag: 'judul',
            child: JudulWidget(size: 24),
          ),
          Hero(
            tag: 'logo_edukasi1',
            child: Image.asset(
              "lib/assets/imgs/logo_edukasi2.png",
              width: 253,
              height: 266,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              "Poin yang bisa dicairkan langsung ke dompet digital.",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 37),
          SmoothPageIndicator(
            controller: pageController,
            count: 2,
            effect: ScaleEffect(
              spacing: 8.0,
              radius: 100.0,
              dotWidth: 12.0,
              dotHeight: 12.0,
              paintStyle:
                  PaintingStyle.fill, // Set to fill to make inactive dots solid
              strokeWidth: 1.5, // Set for border thickness on the active dot
              dotColor: Colors.grey, // Inactive dots are white
              activeDotColor: GreenPointColor.abu, // Active dot with gray color
            ),
          ),
          const SizedBox(height: 20),
          TombolWidget(
            warna: GreenPointColor.secondary,
            warnaText: Colors.white,
            text: "Masuk",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MasukPage()));
            },
          ),
        ],
      ),
    );
  }
}
