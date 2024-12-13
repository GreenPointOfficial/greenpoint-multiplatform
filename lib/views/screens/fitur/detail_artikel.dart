import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/models/artikel_model.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';

class DetailArtikel extends StatefulWidget {
  final Artikel artikel;
  final List<Artikel> rekomendasiArtikel; // Tambahkan list artikel rekomendasi

  const DetailArtikel({
    Key? key,
    required this.artikel,
    this.rekomendasiArtikel = const [], // Default kosong
  }) : super(key: key);

  @override
  _DetailArtikelState createState() => _DetailArtikelState();
}

class _DetailArtikelState extends State<DetailArtikel> {
  @override
  Widget build(BuildContext context) {
    final artikel = widget.artikel;
    final screenWidth = ScreenUtils.screenWidth(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderImage(artikel, screenWidth),
                title: Padding(
                  padding: const EdgeInsets.all( 8.0),
                  child: Text(
                    artikel.judul ?? "Detail Artikel",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                centerTitle: true,
              ),
            ),

            // Konten Artikel
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tanggal dan Penulis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          artikel.tanggal?.toString() ??
                              "Tanggal tidak tersedia",
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: GreenPointColor.primary,
                          ),
                        ),
                        // Tambahkan badge kategori atau penulis jika ada
                        _buildKategoriChip(),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Isi Artikel
                    Text(
                      artikel.isi ?? "Isi artikel tidak tersedia",
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Rekomendasi Artikel
            if (widget.rekomendasiArtikel.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildRekomendasiArtikel(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(Artikel artikel, double screenWidth) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gambar utama
        artikel.foto != null && artikel.foto!.isNotEmpty
            ? Image.network(
                artikel.foto!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage(screenWidth);
                },
              )
            : _buildPlaceholderImage(screenWidth),

        // Gradient overlay untuk readability
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage(double size) {
    return Image.asset(
      "lib/assets/imgs/placeholder.png",
      width: size,
      height: 300,
      fit: BoxFit.cover,
    );
  }

  Widget _buildKategoriChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: GreenPointColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Lingkungan", 
        style: GoogleFonts.dmSans(
          fontSize: 11,
          color: GreenPointColor.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRekomendasiArtikel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text(
            "Artikel Terkait",
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.rekomendasiArtikel.length,
            itemBuilder: (context, index) {
              final artikelRekomendasi = widget.rekomendasiArtikel[index];
              return GestureDetector(
                onTap: () {
                  // Navigasi ke detail artikel yang direkomendasi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailArtikel(
                        artikel: artikelRekomendasi,
                        rekomendasiArtikel: widget.rekomendasiArtikel
                            .where((a) => a != artikelRekomendasi)
                            .toList(),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.network(
                          artikelRekomendasi.foto ?? '',
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "lib/assets/imgs/placeholder.png",
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          artikelRekomendasi.judul ?? 'Artikel Terkait',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
