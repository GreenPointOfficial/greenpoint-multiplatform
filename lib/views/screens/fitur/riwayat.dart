import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/penjualan_controller.dart';
import 'package:greenpoint/models/penjualan_model.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  void initState() {
    super.initState();
    // Panggil fetchRiwayatPenjualan setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PenjualanController>(context, listen: false)
          .getRiwayatPenjualan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final penjualanController = Provider.of<PenjualanController>(context);
    List<RiwayatPenjualan> riwayat = [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Appbar2Widget(title: "Riwayat Penjualan"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Tentukan apakah layar kecil atau besar
          bool isSmallScreen = constraints.maxWidth < 600;

          riwayat = penjualanController.riwayatPenjualanList;
          print(riwayat);
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 32, // Padding responsif
              vertical: 0,
            ),
            child: penjualanController.isLoading
                ?  Center(child: CircularProgressIndicator(
                   color: GreenPointColor.secondary,
                ))
                // : penjualanController.errorMessage != null
                //     ? Center(
                //         child: Text(
                //           penjualanController.errorMessage.toString(),
                //           textAlign: TextAlign.center,
                //           style: GoogleFonts.dmSans(
                //               fontSize: 14, color: GreenPointColor.secondary),
                //         ),
                //       )
                    : penjualanController.riwayatPenjualanList.isEmpty
                        // Center widget to display the "No transaction history" message
                        ? Center(
                            child: Text(
                              "Belum ada riwayat transaksi.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: GreenPointColor
                                    .abu, // Or any color you like
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                penjualanController.riwayatPenjualanList.length,
                            itemBuilder: (context, index) {
                              // Urutkan daftar berdasarkan tanggal (descending)
                              final sortedList = List<RiwayatPenjualan>.from(
                                  penjualanController.riwayatPenjualanList)
                                ..sort((a, b) => b.tanggal
                                    .compareTo(a.tanggal)); // Sort descending
                              final riwayatPenjualan = sortedList[index];
                              return _buildTransaksiCard(
                                  riwayatPenjualan, isSmallScreen);
                            },
                          ),
          );
        },
      ),
    );
  }

  Widget _buildTransaksiCard(
      RiwayatPenjualan riwayatPenjualan, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: isSmallScreen ? 35 : 50,
                    width: isSmallScreen ? 35 : 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFF6FAFD),
                    ),
                    child: Image.asset(
                      'lib/assets/imgs/poin.png',
                      width: isSmallScreen ? 20 : 30,
                      height: isSmallScreen ? 20 : 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Poin masuk",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 12 : 16,
                        ),
                      ),
                      Text(
                        riwayatPenjualan.items.isNotEmpty
                            ? "Status: Berhasil"
                            : "Status: Belum Ada Item",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.normal,
                          fontSize: isSmallScreen ? 10 : 14,
                        ),
                      ),
                      Text(
                        "Tanggal: ${riwayatPenjualan.tanggal}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.normal,
                          color: GreenPointColor.abu,
                          fontSize: isSmallScreen ? 10 : 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "+",
                        style: GoogleFonts.dmSans(
                          color: GreenPointColor.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                      Image.asset(
                        'lib/assets/imgs/poin.png',
                        height: isSmallScreen ? 15 : 20,
                        width: isSmallScreen ? 15 : 20,
                      ),
                      Text(
                        riwayatPenjualan.items.isNotEmpty
                            ? riwayatPenjualan.items[0].totalHarga.toString()
                            : "0",
                        style: GoogleFonts.dmSans(
                          color: GreenPointColor.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    riwayatPenjualan.items.isNotEmpty
                        ? "${riwayatPenjualan.items[0].jumlah} Kg sampah"
                        : "0 Kg",
                    style: GoogleFonts.dmSans(
                      color: GreenPointColor.abu,
                      fontWeight: FontWeight.w500,
                      fontSize: isSmallScreen ? 10 : 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
