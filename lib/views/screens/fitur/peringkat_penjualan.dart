import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/penjualan_controller.dart';
import 'package:greenpoint/models/top_penjualan_model.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
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
      appBar: AppbarWidget(
        title: "Peringkat Penjualan",
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      text: DateFormat('MMM yyyy').format(DateTime.now()),
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: GreenPointColor.primary,
                      ),
                    )
                  ]),
                ),
              ),
              _buildPenjualanTerbanyakSection()
            ],
          ),
        ),
      ),
    );
  }
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
          _buildPodiumPenjualan(context, penjualanController.topPenjualanList),
          _buildSisaPenjualanList(penjualanController.topPenjualanList),
        ],
      );
    },
  );
}

Widget _buildPodiumPenjualan(BuildContext context, List<TopPenjualan> penjualanList) {
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
            // Podium untuk 2nd Place (Kiri)
            if (topThree.length > 1)
              Positioned(
                left: constraints.maxWidth * 0.1, // Relatif terhadap lebar kontainer
                bottom: 0,
                child: _buildPodiumItem(
                  topThree[1], 
                  2, 
                  height: 150, 
                  color: Colors.grey[300]!
                ),
              ),
            
            // Podium untuk 1st Place (Tengah)
            if (topThree.isNotEmpty)
              Positioned(
                left: constraints.maxWidth * 0.35, // Relatif terhadap lebar kontainer
                bottom: 0,
                child: _buildPodiumItem(
                  topThree[0], 
                  1, 
                  height: 200, 
                  color: Colors.amber[200]!
                ),
              ),
            
            // Podium untuk 3rd Place (Kanan)
            if (topThree.length > 2)
              Positioned(
                right: constraints.maxWidth * 0.1, // Relatif terhadap lebar kontainer
                bottom: 0,
                child: _buildPodiumItem(
                  topThree[2], 
                  3, 
                  height: 100, 
                  color: Colors.brown[200]!
                ),
              ),
          ],
        );
      },
    ),
  );
}

Widget _buildPodiumItem(
  TopPenjualan penjualan, 
  int ranking, 
  {required double height, 
  required Color color}
) {
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
Widget _buildSisaPenjualanList(List<TopPenjualan> penjualanList) {
  // Mulai dari index 3 untuk menghindari 3 peringkat teratas
  final sisaPenjualan = penjualanList.skip(3).toList();
  
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: sisaPenjualan.length,
    itemBuilder: (context, index) {
      final penjualan = sisaPenjualan[index];
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: GreenPointColor.primary.withOpacity(0.2),
            child: Text(
              "${index + 4}",
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: GreenPointColor.primary,
              ),
            ),
          ),
          title: Text(
            penjualan.userName,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: GreenPointColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${penjualan.totalBerat} Kg",
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: GreenPointColor.primary,
              ),
            ),
          ),
        ),
      );
    },
  );

}