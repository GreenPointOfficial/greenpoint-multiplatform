import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/models/artikel_model.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';

class DetailArtikel extends StatefulWidget {
  const DetailArtikel(
    {Key? key,
    required Artikel artikel,
    }) : super(key: key);

  @override
  _DetailArtikelState createState() => _DetailArtikelState();
}

class _DetailArtikelState extends State<DetailArtikel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar2Widget(title: "Detail Artikel"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Center(
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: GreenPointColor.abu),
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.network(
                    '',
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, ',
                style: GoogleFonts.dmSans(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment:
                    Alignment.centerLeft, // Align the text to the start (left)
                child: Text(
                  '24 Okt 2024',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: GreenPointColor.primary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum lorem ."
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum lorem ."
              ),
            )
          ],
        ),
      ),
    );
  }
}
