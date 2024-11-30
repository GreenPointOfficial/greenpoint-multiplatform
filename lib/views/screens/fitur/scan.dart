import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:provider/provider.dart';
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
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? scanResult;
  bool isLoading = false;
  bool canScan = true;

  Future<void> claimPoints(String scanResult) async {
    final url = Uri.parse(scanResult);
    final token = await _secureStorage.read(key: 'auth_token');

    try {
      setState(() {
        isLoading = true;
        canScan = false;
      });

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final poin = responseData['poin'];
        final penjualanId = responseData['penjualan_id'];
        final totalHarga = responseData['total_harga'];

        _showDialog(
          totalPrice: totalHarga,
          transactionId: penjualanId,
          poin: poin,
          'Berhasil!',
          'Terima kasih telah menggunakan GreenPoint.',
          isError: false,
        );

        Provider.of<UserProvider>(context, listen: false).autoRefreshUserData({
          'poin': poin + Provider.of<UserProvider>(context, listen: false).poin
        });
      } else {
        final responseData = json.decode(response.body);
        _showDialog(
          totalPrice: 0,
          transactionId: '',
          poin: 0,
          'Gagal!',
          responseData['error'] ??
              'Tidak dapat memproses permintaan Anda. Silakan coba lagi nanti.',
          isError: true,
        );

        setState(() {
          canScan = true;
          scanResult = '';
        });
      }
    } catch (error) {
      print('Error: $error'); // Log untuk error yang terjadi
      _showDialog(
        totalPrice: 0,
        transactionId: '',
        poin: 0,
        'Koneksi Gagal',
        'Terjadi kesalahan dalam koneksi. Pastikan Anda memiliki jaringan internet yang stabil dan coba lagi.',
        isError: true,
      );

      setState(() {
        canScan = true;
        scanResult = '';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDialog(String title, String message,
      {bool isError = false,
      required int poin,
      required int totalPrice,
      required String transactionId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Point logo and points
              Row(
                children: [
                  Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFF6FAFD),
                      ),
                      child: Image.asset(
                        'lib/assets/imgs/poin.png', // Your point logo
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$poin Poin', // Display points
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Center(
                child: Row(
                  children: [
                    Text(
                      'Total Harga: Rp. $totalPrice',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Center(
                child: Row(
                  children: [
                    Text(
                      'ID Transaksi: $transactionId',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Text(
                textAlign: TextAlign.center,
                message,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  canScan = true;
                  scanResult = null;
                });
              },
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    'Konfirmasi',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
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
    final poin = Provider.of<UserProvider>(context).poin;

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
                    if (canScan && scanResult == null) {
                      setState(() {
                        scanResult = result.toString();
                      });
                      claimPoints(scanResult!);
                    }
                  },
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                ),
                Align(
                  alignment: const Alignment(0, -0.2),
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
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.32,
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
                      Container(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10),
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Untuk melanjutkan, harap scan barcode pada struk yang diberikan oleh petugas bank sampah.",
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                ),
                              ),
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
                                    poin.toString(),
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: GreenPointColor.primary,
              ),
            ),
        ],
      ),
    );
  }
}
