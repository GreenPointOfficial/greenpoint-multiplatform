import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/dampak_controller.dart';
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
    // Fetch the dampak data when the screen is loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dampakController =
          Provider.of<DampakController>(context, listen: false);
      dampakController.fetchDampakByIdJenisSampah(widget.jenisSampah.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dampakController = Provider.of<DampakController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(title: "Informasi ${widget.jenisSampah.judul}"),
      body: dampakController.isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: customContainer(
                      imagePath: widget.jenisSampah.foto,
                      title: widget.jenisSampah.judul,
                      price: "Rp. ${widget.jenisSampah.harga}/kg",
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  // Check if dampak data is available, else show a message
                 dampakController.dampakByIdJenisSampah.isEmpty
    ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "Dampak tidak tersedia",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red),
          ),
        ),
      )
    : Column(
        children: dampakController.dampakByIdJenisSampah.map((dampak) {
          return buildCustomContainer(
            context,
            dampak.isi,
            dampak.id,
            dampak.foto,
          );
        }).toList(),
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

  // Method to build the custom container for each dampak
  Widget buildCustomContainer(
      BuildContext context, String text, int index, String foto) {
    final borderColor = index % 2 == 0
        ? GreenPointColor.secondary // Even index
        : GreenPointColor.primary; // Odd index

    final isOdd = index % 2 != 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
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
          if (isOdd) ...[
            buildImageContainer(foto), // Pass dampak.foto here
            const SizedBox(width: 10),
            Expanded(child: buildTextContainer(text)),
          ] else ...[
            Expanded(child: buildTextContainer(text)),
            const SizedBox(width: 10),
            buildImageContainer(foto), // Pass dampak.foto here
          ],
        ],
      ),
    );
  }

  // Method to build the image container for each dampak
  Widget buildImageContainer(String foto) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(foto), // Use foto from dampak
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Method to build the text container for each dampak
  Widget buildTextContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Method to build the grid of daur ulang items
  Widget _buildInformasiSampahGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: 4, // Example grid item count
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Kardus $index",
                style: GoogleFonts.dmSans(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      },
    );
  }

  // Custom container to display details like title, image, and price
  Widget customContainer(
      {required String imagePath,
      required String title,
      required String price}) {
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
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
