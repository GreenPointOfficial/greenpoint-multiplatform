import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/controllers/artikel_controller.dart';
import 'package:greenpoint/controllers/penjualan_controller.dart';
import 'package:greenpoint/models/top_penjualan_model.dart';
import 'package:greenpoint/providers/notifikasi_provider.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/views/screens/fitur/notifikasi.dart';
import 'package:greenpoint/views/widget/notifikasi_widget.dart';
import 'package:intl/intl.dart';
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
            _buildPenjualanTerbanyakSection(),
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

  Widget _buildPenjualanTerbanyakSection() {
    return Consumer<PenjualanController>(
      builder: (context, penjualanController, _) {
        if (penjualanController.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: GreenPointColor.secondary,
            ),
          );
        }

        if (penjualanController.topPenjualanList.isEmpty) {
          return const Center(child: Text("Belum ada data penjualan."));
        }
        return Column(
          children: [
            _buildPodiumPenjualan(
                context, penjualanController.topPenjualanList),
            // _buildSisaPenjualanList(penjualanController.topPenjualanList),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    // Akses unreadCount dari provider
    final int unreadCount = context.watch<NotifikasiProvider>().unreadCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "lib/assets/imgs/logo.png",
          width: screenWidth * 0.15,
          height: screenWidth * 0.1,
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$unreadCount', // Menampilkan jumlah notifikasi
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

Widget _buildPointsSection() {
  final screenWidth = MediaQuery.of(context).size.width;

  // Gaya teks untuk judul
  final TextStyle titleStyle = GoogleFonts.dmSans(
    fontWeight: FontWeight.bold,
    fontSize: screenWidth * 0.045,
  );

  // Fungsi untuk memotong teks dan menambahkan elipsis
  String addEllipsis(String text) {
    if (text.length > 8) {
      return text.substring(0, 9) + '...'; // Potong hingga 8 karakter
    }
    return text;
  }

  // Gaya teks untuk subtitle
  final TextStyle subtitleStyle = GoogleFonts.dmSans(
    fontSize: screenWidth * 0.035,
    color: GreenPointColor.abu,
  );

  // Gaya teks untuk poin
  final TextStyle pointsStyle = GoogleFonts.dmSans(
    fontWeight: FontWeight.bold,
    fontSize: screenWidth * 0.07,
  );

  // Ambil data pengguna dari provider
  final userName = Provider.of<UserProvider>(context).userName;
  final poin = Provider.of<UserProvider>(context).poin;

  // Format poin menjadi format mata uang (Rp)
  final formattedPoin = NumberFormat.currency(
    locale: 'id', 
    symbol: 'Rp', 
    decimalDigits: 0,
  ).format(poin);

  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(addEllipsis("Hello, $userName"), style: titleStyle),
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
          Text(formattedPoin, style: pointsStyle),
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
          return Center(
            child: CircularProgressIndicator(
              color: GreenPointColor.secondary,
            ),
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
          return Center(
              child: CircularProgressIndicator(
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                artikel.foto,
                                fit: BoxFit.cover,
                                width: ScreenUtils.screenWidth(context) * 0.3,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderImage(
                                      ScreenUtils.screenWidth(context) * 0.3);
                                },
                              ),
                            )
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

  Widget _buildPodiumPenjualan(
      BuildContext context, List<TopPenjualan> penjualanList) {
    // Batasi hanya 3 peringkat teratas
    final topThree = penjualanList.take(3).toList();

    return Container(
      height: 250,
      margin: EdgeInsets.only(bottom: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (topThree.length > 1)
                Positioned(
                  left: constraints.maxWidth * 0.1,
                  bottom: 0,
                  child: _buildPodiumItem(topThree[1], 2,
                      height: 150, color: Colors.grey[300]!),
                ),
              if (topThree.isNotEmpty)
                Positioned(
                  left: constraints.maxWidth * 0.365,
                  bottom: 0,
                  child: _buildPodiumItem(topThree[0], 1,
                      height: 200, color: Colors.amber[200]!),
                ),
              if (topThree.length > 2)
                Positioned(
                  right: constraints.maxWidth * 0.1,
                  bottom: 0,
                  child: _buildPodiumItem(topThree[2], 3,
                      height: 100, color: Colors.green[400]!),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPodiumItem(TopPenjualan penjualan, int ranking,
      {required double height, required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: height,
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                penjualan.totalBerat.toString() + "Kg",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                penjualan.userName,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          "Peringkat $ranking",
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
