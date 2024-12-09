import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/models/artikel_model.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';

class DetailArtikel extends StatefulWidget {
  final Artikel artikel;
  const DetailArtikel({
    Key? key,
    required this.artikel,
  }) : super(key: key);

  @override
  _DetailArtikelState createState() => _DetailArtikelState();
}

class _DetailArtikelState extends State<DetailArtikel> {
  @override
  Widget build(BuildContext context) {
    final artikel = widget.artikel;

    return PopScope(
        canPop: false, // Prevents default back behavior
        onPopInvoked: (didPop) {
          if (didPop) return;
          // Custom back navigation logic
          Navigator.of(context).pop(); // Or your custom back navigation
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: Appbar2Widget(title: "Detail Artikel"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align semua elemen ke kiri
              children: [
                // Menampilkan gambar artikel
                Center(
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: GreenPointColor.abu),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: artikel.foto != null && artikel.foto!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(artikel.foto,
                                fit: BoxFit.cover,
                                // width: ScreenUtils.screenWidth(context) * 0.3,
                                errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage(
                                  ScreenUtils.screenWidth(context) * 0.9);
                            }),
                          )
                        : const Center(
                            child: Text("Gambar tidak tersedia"),
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),

                Text(
                  artikel.judul ?? "Judul tidak tersedia",
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),

                Text(
                  artikel.tanggal.toString() ?? "Tanggal tidak tersedia",
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: GreenPointColor.primary,
                  ),
                ),
                const SizedBox(height: 16.0),

                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      artikel.isi ?? "Isi artikel tidak tersedia",
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildPlaceholderImage(double size) {
    return Image.asset(
      "lib/assets/imgs/placeholder.png",
      width: size * 0.7,
      height: size * 0.7,
      fit: BoxFit.contain,
    );
  }
}
