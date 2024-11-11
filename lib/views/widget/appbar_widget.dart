import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? title2;

  const AppbarWidget({
    Key? key,
    required this.title,
    this.title2,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(120); // Use a fixed height here instead of context-based height

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtils.screenWidth(context);
    double screenHeight = ScreenUtils.screenHeight(context);

    double titleFontSize = screenWidth * 0.05; 
    double subtitleFontSize = screenWidth * 0.04; 
    return AppBar(
      backgroundColor: GreenPointColor.secondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        iconSize: screenWidth * 0.08, // Responsive icon size
      ),
      title: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.02, // Adjust top padding based on screen height
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: titleFontSize, // Responsive title font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            if (title2 != null)
              Text(
                title2!,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: subtitleFontSize, // Responsive subtitle font size
                ),
              ),
          ],
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}
