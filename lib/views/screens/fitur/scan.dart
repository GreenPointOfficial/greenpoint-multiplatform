import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
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
          // QR Scanner area positioned at top center
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height *
                0.4, // Adjust this value to move up/down
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: Colors.white70,
                  ),
                ],
              ),
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
                                    "1.000",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
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
                                "Scan",
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
}
