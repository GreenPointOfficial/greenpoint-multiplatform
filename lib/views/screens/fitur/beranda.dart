import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/controllers/artikel_controller.dart';
import 'package:greenpoint/controllers/penjualan_controller.dart';
import 'package:greenpoint/models/top_penjualan_model.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/jenis_sampah_controller.dart';
import 'package:greenpoint/models/jenis_sampah_model.dart';
import 'package:greenpoint/views/screens/fitur/artikel.dart';
import 'package:greenpoint/views/screens/fitur/detail_artikel.dart';
import 'package:greenpoint/views/screens/fitur/informasi_sampah.dart';
import 'package:greenpoint/views/screens/fitur/pencapaian.dart';
import 'package:greenpoint/views/screens/fitur/peringkat_penjualan.dart';
import 'package:greenpoint/views/screens/fitur/riwayat.dart';
import 'package:greenpoint/views/screens/fitur/scan.dart';
import 'package:greenpoint/views/screens/fitur/transaksi.dart';

class ActionItem {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  ActionItem(this.label, this.iconPath, this.onTap);
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUserData();

    // _jenisSampahController.init();
    // Menambahkan post-frame callback untuk menunda pengambilan data setelah build
    _fetchInitialData();
  }

  void _fetchInitialData() async {
    try {
      // Mengambil data JenisSampah dan Artikel setelah build selesai
      await context.read<JenisSampahController>().fetchJenisSampah();
      await context.read<ArtikelController>().fetchAllArtikel();
      await context.read<PenjualanController>().getTopPenjualan();
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<JenisSampahController>(
        builder: (context, jenisSampahController, _) {
          return _buildMainContent(jenisSampahController);
        },
      ),
    );
  }

  Widget _buildMainContent(JenisSampahController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.06;
    final verticalPadding = screenWidth * 0.07;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
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
            "Informasi Sampah",
            _buildInformasiSampahGrid(
                controller.jenisSampahList, controller.isLoading),
            false,
            () {},
          ),
          const SizedBox(height: 20),
          _buildSectionWithTitle(
            "Artikel",
            _buildCardArtikel(),
            true,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArtikelPage()),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionWithTitle(
            "Peringkat Penjualan",
            _buildPenjualanTerbanyakSection(), // Tambahkan section penjualan terbanyak
            true,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PeringkatPenjualan()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "lib/assets/imgs/logo.png",
          width: screenWidth * 0.15,
          height: screenWidth * 0.1,
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notifications
          },
        ),
      ],
    );
  }

  Widget _buildPointsSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextStyle titleStyle = GoogleFonts.dmSans(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.045,
    );
    final TextStyle subtitleStyle = GoogleFonts.dmSans(
      fontSize: screenWidth * 0.035,
      color: GreenPointColor.abu,
    );
    final TextStyle pointsStyle = GoogleFonts.dmSans(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.07,
    );

    final userName = Provider.of<UserProvider>(context).userName;
    final poin = Provider.of<UserProvider>(context).poin;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, $userName", style: titleStyle),
            Text("Poin kamu saat ini", style: subtitleStyle),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Image.asset(
              "lib/assets/imgs/poin.png",
              height: screenWidth * 0.09,
              width: screenWidth * 0.09,
            ),
            const SizedBox(width: 8),
            Text(poin.toString(), style: pointsStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final actions = [
      _buildActionItem("Scan", "lib/assets/imgs/scan.png", () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ScanPage()));
      }),
      _buildActionItem("Transaksi", "lib/assets/imgs/tukar.png", () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TransaksiPage()));
      }),
      _buildActionItem("Riwayat", "lib/assets/imgs/riwayat.png", () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RiwayatPage()));
      }),
      _buildActionItem("Pencapaian", "lib/assets/imgs/pencapaian.png", () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PencapaianPage()));
      }),
    ];

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: GreenPointColor.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return Row(
            children: [
              action,
              if (index < actions.length - 1) _buildDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionItem(String label, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 45, height: 45),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
  }

  Widget _buildSectionWithTitle(
    String title,
    Widget content,
    bool seeMore,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (seeMore)
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Lihat semua",
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: GreenPointColor.primary,
                  ),
                ),
              ),
          ],
        ),
        // const SizedBox(height: 15),
        content,
      ],
    );
  }

  Widget _buildInformasiSampahGrid(
      List<JenisSampah> jenisSampahList, bool isLoading) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final itemWidth = (availableWidth - (3 * 27)) / 4;

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (jenisSampahList.isEmpty) {
          return const Center(
            child: Text("Informasi sampah tidak tersedia."),
          );
        }

        return Wrap(
          spacing: 27,
          runSpacing: 16,
          children: jenisSampahList.map((jenisSampah) {
            final imagePath = jenisSampah.foto.isNotEmpty
                ? jenisSampah.foto
                : "lib/assets/imgs/placeholder.png";
            final nama =
                jenisSampah.judul.isNotEmpty ? jenisSampah.judul : "Unknown";

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InformasiSampah(jenisSampah: jenisSampah),
                ),
              ),
              child: SizedBox(
                width: itemWidth,
                child: _buildInformasiSampahItem(imagePath, nama),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildInformasiSampahItem(String imagePath, String name) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = constraints.maxWidth * 0.9;

        return Column(
          children: [
            Container(
              height: containerSize,
              width: containerSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFF6FAFD),
              ),
              child: Center(
                child: _buildImage(imagePath, containerSize),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: GoogleFonts.dmSans(fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String path, double size) {
    return path.startsWith('http') || path.startsWith('https')
        ? Image.network(
            path,
            width: size * 0.7,
            height: size * 0.7,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderImage(size);
            },
          )
        : Image.asset(
            path,
            width: size * 0.7,
            height: size * 0.7,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderImage(size);
            },
          );
  }

  Widget _buildPlaceholderImage(double size) {
    return Image.asset(
      "lib/assets/imgs/placeholder.png",
      width: size * 0.7,
      height: size * 0.7,
      fit: BoxFit.contain,
    );
  }

  Widget _buildCardArtikel() {
    return Consumer<ArtikelController>(
      builder: (context, artikelController, _) {
        if (artikelController.isLoading) {
          return  Center(child: CircularProgressIndicator(
            color: GreenPointColor.secondary,
          ));
        }

        if (artikelController.artikelList.isEmpty) {
          return const Center(child: Text("Belum ada artikel."));
        }

        return Column(
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: artikelController.artikelList.length,
                padEnds: false,
                itemBuilder: (context, index) {
                  final artikel = artikelController.artikelList[index];
                  final cardColor = index.isEven
                      ? GreenPointColor.secondary
                      : GreenPointColor.abu;

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailArtikel(artikel: artikel),
                      ),
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
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
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      artikel.isi,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Baca Selengkapnya",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.network(
                              artikel.foto,
                              width: ScreenUtils.screenWidth(context) * 0.3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            SmoothPageIndicator(
              controller: _pageController,
              count: artikelController.artikelList.length,
              effect: ExpandingDotsEffect(
                dotWidth: 8,
                dotHeight: 8,
                activeDotColor: GreenPointColor.secondary,
                dotColor: Colors.grey.shade300,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPenjualanTerbanyakSection() {
    return Consumer<PenjualanController>(
      builder: (context, penjualanController, _) {
        if (penjualanController.isLoading) {
          return  Center(child: CircularProgressIndicator(
            color: GreenPointColor.secondary,
          ));
        }

        if (penjualanController.topPenjualanList.isEmpty) {
          return const Center(child: Text("Belum ada data penjualan."));
        }
        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPenjualanTerbanyakList(penjualanController.topPenjualanList),
          ],
        );
      },
    );
  }

  Widget _buildPenjualanTerbanyakList(List<TopPenjualan> penjualanList) {
  final int itemCount = min(penjualanList.length, 5);

  return ListView.builder(
    shrinkWrap: true,
    padding: EdgeInsets.only(top: 0),
    physics: NeverScrollableScrollPhysics(),
    itemCount: itemCount, // Hanya menampilkan maksimal 5 item
    itemBuilder: (context, index) {
      final penjualan = penjualanList[index];
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: "${index + 1}. ",
                    style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text: penjualan.userName,
                        style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${penjualan.totalBerat} Kg",
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: GreenPointColor.primary),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}}  
