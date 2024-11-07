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
  Size get preferredSize => const Size.fromHeight(114); 

  @override
  Widget build(BuildContext context) {
    return AppBar(
    
      backgroundColor: GreenPointColor.secondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        iconSize: 24, // Ukuran icon lebih besar agar lebih mudah diklik
      ),
      title: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.screenHeight(context) * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            if (title2 != null)
              Text(
                title2!,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 14,
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
