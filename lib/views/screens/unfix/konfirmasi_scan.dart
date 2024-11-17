import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KonfirmasiScan extends StatefulWidget {
  const KonfirmasiScan({Key? key}) : super(key: key);

  @override
  _KonfirmasiScanState createState() => _KonfirmasiScanState();
}

class _KonfirmasiScanState extends State<KonfirmasiScan> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Rincian poin Anda",
            style:
                GoogleFonts.dmSans(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 490,
            width: 325,
            child: Column(
              children: [
                Row(
                  
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
