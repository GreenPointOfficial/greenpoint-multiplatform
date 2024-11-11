import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';

class JudulWidget extends StatelessWidget {
  final double size;
  const JudulWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = ScreenUtils.screenHeight(context);
        final double screenWidth = ScreenUtils.screenWidth(context);

    
    double scaledSize = screenWidth * 0.08; // Adjust the scaling factor as needed

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Extra padding
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: scaledSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            height: 1.0,
            shadows: [
              Shadow(
                color: Colors.grey.withOpacity(0.35),
                offset: const Offset(3, 3),
                blurRadius: 6,
              ),
            ],
          ),
          children: [
            TextSpan(
              text: "Selamat datang\n",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: scaledSize,
                fontWeight: FontWeight.w700, // Emphasis on the greeting
              ),
            ),
            TextSpan(
              text: "di ",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: scaledSize * 0.9, // Slightly smaller for "di"
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: "Green",
              style: GoogleFonts.poppins(
                color: GreenPointColor.primary,
                fontSize: scaledSize,
                fontWeight: FontWeight.w800, // Heavier for emphasis
              ),
            ),
            TextSpan(
              text: "Point",
              style: GoogleFonts.poppins(
                color: GreenPointColor.orange,
                fontSize: scaledSize,
                fontWeight: FontWeight.w800, // Consistent boldness for brand name
              ),
            ),
          ],
        ),
      ),
    );
  }
}
