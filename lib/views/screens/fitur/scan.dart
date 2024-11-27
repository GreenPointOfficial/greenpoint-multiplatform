import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? scanResult; // Hasil scan QR Code

  Future<void> claimPoints(String scanResult) async {
  final url = Uri.parse(scanResult);

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final poin = responseData['poin'];
      final penjualanId = responseData['penjualan_id'];

      // Show success dialog with structured data
      _showDialog(
        'Berhasil!',
        'Poin berhasil diklaim:\n\n'
        '- **Jumlah Poin**: $poin\n'
        '- **ID Penjualan**: $penjualanId\n\n'
        'Terima kasih telah menggunakan GreenPoint.',
        isError: false,
      );
    } else {
      final responseData = json.decode(response.body);
      _showDialog(
        'Gagal!',
        responseData['error'] ??
            'Tidak dapat memproses permintaan Anda. Silakan coba lagi nanti.',
        isError: true,
      );
    }
  } catch (error) {
    _showDialog(
      'Koneksi Gagal',
      'Terjadi kesalahan dalam koneksi. Pastikan Anda memiliki jaringan internet yang stabil dan coba lagi.',
      isError: true,
    );
  }
}

void _showDialog(String title, String message, {bool isError = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.red : Colors.green,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isError ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.dmSans(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isError ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      );
    },
  );
}
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GreenPointColor.primary,
      appBar: AppBar(
        backgroundColor: GreenPointColor.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 24,
        ),
        title: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.screenHeight(context) * 0.01,
          ),
          child: Text(
            "Scan",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                QRCodeDartScanView(
                  scanInvertedQRCode: true,
                  onCapture: (result) {
                    setState(() {
                      scanResult = result.toString();
                    });
                    if (scanResult != null) {
                      claimPoints(scanResult!);
                    }
                  },
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                ),
                Align(
                  alignment: Alignment(0, -0.2),
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 4,
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Draggable bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.horizontal_rule,
                        color: Colors.grey,
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              "Scan",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Divider(),
                            Text(
                              "Untuk melanjutkan, harap scan barcode pada struk yang diberikan oleh petugas bank sampah.",
                              style: GoogleFonts.dmSans(fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 43,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(179, 222, 221, 221),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "lib/assets/imgs/poin.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Poin Kamu",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "1.000",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (scanResult == null) {
                                  _showDialog1("Belum ada hasil scan.");
                                } else {
                                  claimPoints(scanResult!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                "Tampilkan Hasil",
                                style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDialog1(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Status'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
