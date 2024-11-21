import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/dampak_controller.dart';
import 'package:greenpoint/controllers/daur_ulang_controller.dart';
import 'package:greenpoint/models/jenis_sampah_model.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dampakController =
          Provider.of<DampakController>(context, listen: false);
      dampakController.fetchDampakByIdJenisSampah(widget.jenisSampah.id);

      final daurUlangController =
          Provider.of<DaurUlangController>(context, listen: false);
      daurUlangController.fetchDaurUlangByIdJenisSampah(widget.jenisSampah.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dampakController = Provider.of<DampakController>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(title: "Informasi ${widget.jenisSampah.judul}"),
      body: dampakController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informasi utama
                    customContainer(
                      imagePath: widget.jenisSampah.foto,
                      title: widget.jenisSampah.judul,
                      price: "Rp. ${widget.jenisSampah.harga}/kg",
                    ),
                    const SizedBox(height: 20),
                    // Dampak Positif
                    Center(
                      child: Text(
                        "Dampak Positif Daur Ulang ${widget.jenisSampah.judul}:",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.02,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    dampakController.dampakByIdJenisSampah.isEmpty
                        ? Center(
                            child: Text(
                              "Dampak tidak tersedia",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: GreenPointColor.abu,
                              ),
                            ),
                          )
                        : Column(
                            children: dampakController.dampakByIdJenisSampah
                                .map((dampak) {
                              return buildCustomContainer(
                                context,
                                dampak.isi,
                                dampak.id,
                                dampak.foto,
                              );
                            }).toList(),
                          ),
                    const SizedBox(height: 20),
                    // Hasil Daur Ulang
                    Center(
                      child: Text(
                        "Hasil Daur Ulang ${widget.jenisSampah.judul}:",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.02,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDaurUlangSampahGrid(screenWidth),
                  ],
                ),
              ),
            ),
    );
  }

  Widget customContainer({
    required String imagePath,
    required String title,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaurUlangSampahGrid(double screenWidth) {
    final daurUlangController = Provider.of<DaurUlangController>(context);

    if (daurUlangController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (daurUlangController.daurUlangByIdJenisSampah.isEmpty) {
      return Center(
        child: Text(
          "Hasil daur ulang tidak tersedia",
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: GreenPointColor.abu,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: daurUlangController.daurUlangByIdJenisSampah.length,
      itemBuilder: (context, index) {
        final item = daurUlangController.daurUlangByIdJenisSampah[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(item.foto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.judul,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget buildCustomContainer(
      BuildContext context, String text, int index, String foto) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: index.isEven
              ? GreenPointColor.secondary
              : GreenPointColor.primary,
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
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(foto),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
