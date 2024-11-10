import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:google_fonts/google_fonts.dart';

class JudulWidget extends StatelessWidget {
  final double size;
  const JudulWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Extra padding
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: size,
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
                fontSize: size,
                fontWeight: FontWeight.w700, // Emphasis on the greeting
              ),
            ),
            TextSpan(
              text: "di ",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: size * 0.9, // Slightly smaller for "di"
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: "Green",
              style: GoogleFonts.poppins(
                color: GreenPointColor.primary,
                fontSize: size,
                fontWeight: FontWeight.w800, // Heavier for emphasis
              ),
            ),
            TextSpan(
              text: "Point",
              style: GoogleFonts.poppins(
                color: GreenPointColor.orange,
                fontSize: size,
                fontWeight: FontWeight.w800, // Consistent boldness for brand name
              ),
            ),
          ],
        ),
      ),
    );
  }
}
