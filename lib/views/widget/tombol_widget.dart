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
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey,
        
        backgroundColor: warna, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), 
        ),
        elevation: 5,
        fixedSize: Size(width ?? 308, 49), 
      ),
      onPressed: onPressed, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetIcon != null) ...[
            Image.asset(
              assetIcon!, 
              height: 38, 
              width: 38, 
            ),
            const SizedBox(width: 8), 
          ] else if (icon != null) ...[
            Icon(icon, color: warnaText), 
            const SizedBox(width: 8), 
          ],
          Text(
            text,
            style: GoogleFonts.dmSans(
              color: warnaText, 
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
