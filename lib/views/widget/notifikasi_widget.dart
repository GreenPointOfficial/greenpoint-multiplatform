import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifikasiWidget extends StatelessWidget {
  final String? notificationMessage;
  final double top; 
  final Color? textColor;

  const NotifikasiWidget({
    Key? key,
    this.notificationMessage,
    this.top = 0.008, // Default top position if not provided
    this.textColor, // Default top position if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * top, // Use the provided top parameter
      left: MediaQuery.of(context).size.width * 0.05, // Adjust based on screen width
      right: MediaQuery.of(context).size.width * 0.05, // Adjust based on screen width
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: notificationMessage != null ? 1.0 : 0.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Reduced padding
          decoration: BoxDecoration(
            color: Colors.transparent, // Slightly transparent
            borderRadius: BorderRadius.circular(6), // Slightly smaller radius
          ),
          child: Text(
            notificationMessage ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: textColor?? Colors.red,
              fontSize: 12, // Slightly smaller font
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
