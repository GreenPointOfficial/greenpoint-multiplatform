import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/models/jenis_sampah_model.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class InformasiSampah extends StatefulWidget {
  final JenisSampah jenisSampah;

  const InformasiSampah({
    Key? key,
    required this.jenisSampah,
  }) : super(key: key);

  @override
  _InformasiSampahState createState() => _InformasiSampahState();
}

class _InformasiSampahState extends State<InformasiSampah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(title: "Informasi ${widget.jenisSampah.judul}"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customContainer(
              imagePath: widget.jenisSampah.foto,

              title: widget.jenisSampah.judul, // Menampilkan nama dinamis
              price:
                  "Rp. ${widget.jenisSampah.harga}/kg", // Menampilkan harga dinamis
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Dampak Positif Daur Ulang ${widget.jenisSampah.judul}:",
                  style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.02),
                ),
              ),
            ),
            buildCustomContainer(
              context,
              "Daur ulang kardus dapat membantu menyelamatkan hutan. Diperkirakan bahwa ketika 1 ton kertas kardus didaur ulang, sekitar 12 hingga 17 pohon diselamatkan.",
              1,
            ),
            buildCustomContainer(
              context,
              "Sampah plastik membutuhkan waktu ratusan tahun untuk terurai dan dapat mencemari tanah serta air tanah.",
              2,
            ),
            buildCustomContainer(
              context,
              "Meningkatnya jumlah sampah di lautan membahayakan ekosistem laut dan satwa liar yang ada di dalamnya.",
              3,
            ),
            buildCustomContainer(
              context,
              "Pembakaran sampah dapat menghasilkan emisi gas rumah kaca yang mempercepat perubahan iklim.",
              4,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Hasil Daur Ulang Kardus:",
                  style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.02),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildInformasiSampahGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomContainer(BuildContext context, String text, int index) {
    final borderColor = index % 2 == 0
        ? GreenPointColor.secondary // Genap
        : GreenPointColor.primary; // Ganjil

    // Tentukan apakah gambar di kiri atau kanan
    final isOdd = index % 2 != 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background putih
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor, // Border sesuai indeks
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar kecil di kiri atau kanan berdasarkan indeks
          if (isOdd) ...[
            buildImageContainer(), // Gambar di kiri untuk indeks ganjil
            const SizedBox(width: 10),
            Expanded(child: buildTextContainer(text)),
          ] else ...[
            Expanded(child: buildTextContainer(text)),
            const SizedBox(width: 10),
            buildImageContainer(), // Gambar di kanan untuk indeks genap
          ],
        ],
      ),
    );
  }

  Widget buildTextContainer(String text) {
    return Text(
      text,
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.dmSans(
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  Widget buildImageContainer() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: GreenPointColor.abu, // Border color
          width: 2, // Border width
        ),
      ),
      child: Image.asset(
        "lib/assets/imgs/logo.png",
        height: 40,
        width: 40,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInformasiSampahGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dua container dalam satu baris
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1, // Proporsi 1:1
      ),
      itemCount: 4, // Jumlah item
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => InformasiSampah()),
            // );
          },
          child: _buildInformasiSampahItem(
            "lib/assets/imgs/logo.png",
            "Item ${index + 1}",
          ),
        );
      },
    );
  }

  Widget _buildInformasiSampahItem(String path, String name) {
    return Column(
      children: [
        Container(
          height: 120, // Tinggi diperbesar
          width: 120, // Lebar diperbesar
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFF6FAFD),
            border: Border.all(
              color: GreenPointColor.abu, // Border color
              width: 2, // Border width
            ),
          ),
          child: Image.asset(path, fit: BoxFit.cover),
        ),
        const SizedBox(height: 10),
        Text(name,
            style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black)),
      ],
    );
  }

  Widget customContainer({
    required String imagePath,
    required String title,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang putih
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GreenPointColor.abu, // Border color
          width: 2, // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Warna bayangan abu-abu
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.03),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.black, // Warna teks hitam
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
