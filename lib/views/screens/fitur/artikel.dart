import 'package:flutter/material.dart';
import 'package:greenpoint/controllers/artikel_controller.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/screens/fitur/detail_artikel.dart';

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({Key? key}) : super(key: key);

  @override
  _ArtikelPageState createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  @override
  void initState() {
    super.initState();
    // Memuat data artikel saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArtikelController>(context, listen: false).fetchAllArtikel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar2Widget(title: "Artikel"),
      body: Consumer<ArtikelController>(
        builder: (context, artikelController, _) {
          if (artikelController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (artikelController.artikelList.isEmpty) {
            return const Center(child: Text("Belum ada artikel."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            itemCount: artikelController.artikelList.length,
            itemBuilder: (context, index) {
              final artikel = artikelController.artikelList[index];
              final cardColor = index.isEven
                  ? GreenPointColor.secondary
                  : GreenPointColor.abu;

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artikel.judul,
                              style: GoogleFonts.dmSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              artikel.isi,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailArtikel(artikel: artikel),
                                  ),
                                );
                              },
                              child: Text(
                                "Baca Selengkapnya",
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15,),
                      SizedBox(
                        width: ScreenUtils.screenWidth(context) * 0.3,
                        child: Image.network(
                          artikel.foto,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Gambar selesai dimuat
                            }
                            // Gambar placeholder saat loading
                            return Image.asset(
                              'lib/assets/imgs/placeholder.png',
                              fit: BoxFit.cover,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // Gambar placeholder saat error
                            return Image.asset(
                              'lib/assets/imgs/placeholder.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
