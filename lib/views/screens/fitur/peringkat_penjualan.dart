import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/penjualan_controller.dart';
import 'package:greenpoint/models/top_penjualan_model.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: DateFormat('MMM yyyy').format(DateTime
                      .now()), // This formats the current month and year
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: GreenPointColor.primary,
                  ),
                )
              ])),
            ),
            _buildPenjualanTerbanyakSection()
          ],
        ),
      ),
    );
  }
}

Widget _buildPenjualanTerbanyakSection() {
  return Consumer<PenjualanController>(
    builder: (context, penjualanController, _) {
      if (penjualanController.isLoading) {
        return const Center(child: CircularProgressIndicator());
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
  return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 0),
      physics: NeverScrollableScrollPhysics(),
      itemCount: penjualanList.length,
      itemBuilder: (context, index) {
        final penjualan = penjualanList[index];
        return Column(children: [
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
                Text(penjualan.totalBerat.toString() + "Kg"!,
                    style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: GreenPointColor.primary)),
              ],
            ),
          ),
        ]);
      });
}
