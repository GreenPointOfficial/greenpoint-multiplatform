import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TombolWidget extends StatelessWidget {
  final Color warna; 
  final Color warnaText; 
  final String text; 
  final VoidCallback onPressed; 
  final IconData? icon; 
  final String? assetIcon; 
  final double? width; 

  const TombolWidget({
    super.key,
    required this.warna,
    required this.warnaText,
    required this.text,
    required this.onPressed,
    this.icon, 
    this.assetIcon, 
    this.width, 
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey,
        backgroundColor: warna, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), 
        ),
        elevation: 5,
        fixedSize: Size(width ?? screenWidth * 0.8, screenWidth * 0.12), // Responsive size
      ),
      onPressed: onPressed, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetIcon != null) ...[
            Image.asset(
              assetIcon!, 
              height: screenWidth * 0.08, // Responsive icon height
              width: screenWidth * 0.08, // Responsive icon width
            ),
            SizedBox(width: screenWidth * 0.02), // Responsive spacing
          ] else if (icon != null) ...[
            Icon(icon, color: warnaText, size: screenWidth * 0.06), // Responsive icon size
            SizedBox(width: screenWidth * 0.02), // Responsive spacing
          ],
          Text(
            text,
            style: GoogleFonts.dmSans(
              color: warnaText, 
              fontSize: screenWidth * 0.04, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
