import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';

class Appbar2Widget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Appbar2Widget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
        iconSize: 24,
      ),
      title: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.screenHeight(context) * 0.01,
        ),
        child: Text(
          title,
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      )),
    );
  }
}
