import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? title2;
  final bool hideLeading; // Properti untuk mengontrol apakah leading dihilangkan atau tidak

  const AppbarWidget({
    Key? key,
    required this.title,
    this.title2,
    this.hideLeading = false, // Default-nya adalah `false`, leading akan ditampilkan
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtils.screenWidth(context);
    double screenHeight = ScreenUtils.screenHeight(context);

    double titleFontSize = screenWidth * 0.04;
    double subtitleFontSize = screenWidth * 0.04;

    return AppBar(
      backgroundColor: GreenPointColor.secondary,
      leading: hideLeading
          ? null 
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              iconSize: screenWidth * 0.06,
            ),
      title: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            if (title2 != null)
              Text(
                title2!,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: subtitleFontSize,
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
