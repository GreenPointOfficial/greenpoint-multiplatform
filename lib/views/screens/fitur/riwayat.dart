import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Appbar2Widget(title: "Riwayat"),
      body: Column(
        children: [
          _buildTransaksiCard(),
          _buildTransaksiCard(),
          _buildTransaksiCard()
        ],
      ),
    );
  }
}

Widget _buildTransaksiCard() {
  return Padding(
    padding: const EdgeInsets.only(
      left: 15.0, right : 15.0, bottom: 5),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFF6FAFD),
                    ),
                    child: Image.asset('lib/assets/imgs/poin.png',
                        width: 20, height: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Jenis",
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Text("Status", style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.normal,
                              fontSize: 10)),
                      Text("Tanggal", style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.normal,
                              color: GreenPointColor.abu,
                              fontSize: 10)),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text("+",
                        style: GoogleFonts.dmSans(
                            color: GreenPointColor.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12)),
                    Image.asset(
                      'lib/assets/imgs/poin.png',
                      height: 15,
                      width: 15,
                    ),
                    Text("5.000",
                        style: GoogleFonts.dmSans(
                            color: GreenPointColor.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12)),
                  ],
                ),
                Text("10 Kg",
                    style: GoogleFonts.dmSans(
                        color: GreenPointColor.abu,
                        fontWeight: FontWeight.w500,
                        fontSize: 12))
              ],
            ),
          ],
        ),
        SizedBox(height: 5,),
        Divider()
      ],
    ),
  );
}
