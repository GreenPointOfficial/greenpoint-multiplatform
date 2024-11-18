import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/views/screens/fitur/detail_artikel.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Artikel extends StatefulWidget {
  const Artikel({Key? key}) : super(key: key);

  @override
  _ArtikelState createState() => _ArtikelState();
}

class _ArtikelState extends State<Artikel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Appbar2Widget(title: "Artikel"),
      body: Padding(
        padding: const EdgeInsets.only(right: 25.0, left: 25, bottom: 27),
        child: ListView.builder(
          itemCount: 5, // Example item count, replace with actual data length
          itemBuilder: (context, index) {
            return _buildArtikelCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildArtikelCard(int index) {
    final cardColor =
        index.isEven ? GreenPointColor.secondary : GreenPointColor.abu;
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Judul ${index + 1}",
                      style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Coba deh ini isinya apa aja si coba lihat lebih detail ini paid oi cui...",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: Colors.white54),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: Text("Baca Selengkapnya",
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailArtikel(), // Replace with the target page
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              width: ScreenUtils.screenWidth(context) * 0.3,
              child: Image.asset('lib/assets/imgs/logo_edukasi1.png'),
            ),
          ],
        ),
      ),
    );
  }
}
