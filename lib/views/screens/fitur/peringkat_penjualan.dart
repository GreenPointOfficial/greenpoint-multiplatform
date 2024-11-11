import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class PeringkatPenjualan extends StatefulWidget {
  const PeringkatPenjualan({Key? key}) : super(key: key);

  @override
  _PeringkatPenjualanState createState() => _PeringkatPenjualanState();
}

class _PeringkatPenjualanState extends State<PeringkatPenjualan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar2Widget(
        title: "Peringkat penjualan",
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 25.0, left: 25, bottom: 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Periode: ",
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                TextSpan(
                  text: "Okt 2024 ",
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: GreenPointColor.primary),
                )
              ])),
            ),
            _buildPenjualanTerbanyak()
          ],
        ),
      ),
    );
  }
}

Widget _buildPenjualanTerbanyak() {
  final List<Map<String, String>> salesData = [
    {'rank': '1', 'name': 'Agus Saputra', 'quantity': '10Kg'},
    {'rank': '2', 'name': 'Budi Santoso', 'quantity': '8Kg'},
    {'rank': '3', 'name': 'Charlie Li', 'quantity': '5Kg'},
    {'rank': '4', 'name': 'Charlie Li', 'quantity': '5Kg'},
    {'rank': '5', 'name': 'Charlie Li', 'quantity': '5Kg'},
    {'rank': '6', 'name': 'Charlie Li', 'quantity': '5Kg'},
    {'rank': '7', 'name': 'Charlie Li', 'quantity': '5Kg'},
    {'rank': '8', 'name': 'Charlie Li', 'quantity': '5Kg'},
    {'rank': '9', 'name': 'Charlie Li', 'quantity': '5Kg'},
    {'rank': '10', 'name': 'Charlie Li', 'quantity': '5Kg'},
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
