import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/views/screens/fitur/artikel.dart';
import 'package:greenpoint/views/screens/fitur/detail_artikel.dart';
import 'package:greenpoint/views/screens/fitur/informasi_sampah.dart';
import 'package:greenpoint/views/screens/fitur/pencapaian.dart';
import 'package:greenpoint/views/screens/fitur/peringkat_penjualan.dart';
import 'package:greenpoint/views/screens/fitur/riwayat.dart';
import 'package:greenpoint/views/screens/fitur/scan.dart';
import 'package:greenpoint/views/screens/fitur/transaksi.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 27.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 5),
            _buildPointsSection(),
            const SizedBox(height: 20),
            _buildActionsSection(),
            const SizedBox(height: 20),
            _buildSectionWithTitle(
                "Informasi Sampah", _buildInformasiSampahGrid(), false, () {}),
            const SizedBox(height: 20),
            _buildSectionWithTitle("Artikel", _buildCardArtikel(), true, () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Artikel()));
            }),
            const SizedBox(height: 20),
            _buildSectionWithTitle(
                "Peringkat Penjualan", _buildPenjualanTerbanyak(), true, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PeringkatPenjualan()));
            })
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "lib/assets/imgs/logo.png",
          width: ScreenUtils.screenWidth(context) * 0.15,
          height: ScreenUtils.screenHeight(context) * 0.1,
        ),
        const Icon(Icons.notifications),
      ],
    );
  }

  Widget _buildPointsSection() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello user!",
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Poin kamu saat ini",
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: GreenPointColor.abu)),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Image.asset("lib/assets/imgs/poin.png", height: 35, width: 35),
            const SizedBox(width: 8),
            Text("1.000.000",
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold, fontSize: 28)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GreenPointColor.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem("Pencapaian", "lib/assets/imgs/pencapaian.png", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PencapaianPage()));
          }),
          _buildDivider(),
          _buildActionItem("Scan", "lib/assets/imgs/scan.png", () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ScanPage()));
          }),
          _buildDivider(),
          _buildActionItem("Transaksi", "lib/assets/imgs/tukar.png", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TransaksiPage()));
          }),
          _buildDivider(),
          _buildActionItem("Riwayat", "lib/assets/imgs/riwayat.png", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RiwayatPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 2,
      height: 40,
      color: Colors.white.withOpacity(0.5),
    );
  }

  Widget _buildActionItem(String label, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(assetPath, height: 35, width: 35),
          const SizedBox(height: 5),
          Text(label,
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSectionWithTitle(
      String title, Widget content, bool seeMore, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
                  GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (seeMore)
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Lihat semua",
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: GreenPointColor.primary),
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        content,
      ],
    );
  }

  Widget _buildInformasiSampahGrid() {
    return Wrap(
      spacing: 27,
      runSpacing: 16,
      children: List.generate(
        8,
        (index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InformasiSampah()),
            );
          },
          child: _buildInformasiSampahItem(
            "lib/assets/imgs/logo.png",
            "Item ${index + 1}",
          ),
        ),
      ),
    );
  }

  Widget _buildInformasiSampahItem(String path, String name) {
    return Column(
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFF6FAFD),
          ),
          child: Image.asset(path, width: 20, height: 20),
        ),
        const SizedBox(height: 10),
        Text(name,
            style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black)),
      ],
    );
  }

  Widget _buildCardArtikel() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 10,
            padEnds: false,
            itemBuilder: (context, index) {
              return _buildArtikelCard(index);
            },
          ),
        ),
        const SizedBox(height: 15),
        SmoothPageIndicator(
          controller: _pageController,
          count: 10,
          effect: ExpandingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: GreenPointColor.primary,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
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
                  const SizedBox(
                    height: 25,
                  ),
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
            Image.asset('lib/assets/imgs/logo_edukasi1.png',
                width: ScreenUtils.screenWidth(context) * 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildPenjualanTerbanyak() {
    final List<Map<String, String>> salesData = [
      {'rank': '1', 'name': 'Agus Saputra', 'quantity': '10Kg'},
      {'rank': '2', 'name': 'Budi Santoso', 'quantity': '8Kg'},
      {'rank': '3', 'name': 'Charlie Li', 'quantity': '5Kg'},
    ];

    return Column(
      children: salesData.asMap().entries.map((entry) {
        int index = entry.key;
        var item = entry.value;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "${item['rank']}. ",
                      style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      children: [
                        TextSpan(
                          text: item['name'],
                          style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Text(item['quantity']!,
                      style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GreenPointColor.primary)),
                ],
              ),
            ),
            if (index < salesData.length - 1)
              Divider(thickness: 0.5, color: Colors.grey[300]),
          ],
        );
      }).toList(),
    );
  }
}
