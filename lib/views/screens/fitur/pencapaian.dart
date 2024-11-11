import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';

class PencapaianPage extends StatefulWidget {
  const PencapaianPage({Key? key}) : super(key: key);

  @override
  _PencapaianPageState createState() => _PencapaianPageState();
}

class _PencapaianPageState extends State<PencapaianPage> {
  double currentProgress = 0.2; // Example progress (20% of 30Kg)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar2Widget(title: "Pencapaian"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Reward Bulanan"),
            _buildRewardContainer(context),
            Container(alignment: Alignment.center,
              child: _buildSectionTitle("Cara Menjual Sampah")),
            _buildStepsSection(),
            Text(
              "Bersama kita wujudkan perubahan kecil yang berdampak besar bagi bumi. ",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: ScreenUtils.screenWidth(context) *
                    0.03, // Adjust font size responsively
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRewardContainer(BuildContext context) {
    return Container(
      width: ScreenUtils.screenWidth(context),
      decoration: BoxDecoration(
        color: GreenPointColor.secondary,
        border: Border.all(),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRewardText("Ayo selamatkan bumi\ndan dapatkan "),
            _buildPointRow("80.000"),
            const Divider(color: Colors.white),
            const SizedBox(height: 10),
            _buildSubTitle("Penjualan anda:"),
            const SizedBox(height: 10),
            _buildProgressBar(context),
            const SizedBox(height: 10),
            _buildMilestones(),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardText(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPointRow(String points) {
    return Row(
      children: [
        Image.asset("lib/assets/imgs/poin.png", height: 25, width: 25),
        const SizedBox(width: 8),
        Text(
          points,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: GreenPointColor.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSubTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          height: 10,
          width: ScreenUtils.screenWidth(context) * currentProgress,
          decoration: BoxDecoration(
            color: GreenPointColor.orange,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMilestone("10Kg", "10.000"),
        _buildMilestone("20Kg", "30.000"),
        _buildMilestone("30Kg", "40.000"),
      ],
    );
  }

  Widget _buildMilestone(String weight, String points) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: GreenPointColor.secondary,
          child: Text(
            weight,
            style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Image.asset("lib/assets/imgs/poin.png", height: 15, width: 15),
            const SizedBox(width: 8),
            Text(
              points,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      children: [
        _buildStepRow(
          "1. Kumpulkan sampah\ndisekitar anda",
          "lib/assets/imgs/step1.png",
        ),
        const Divider(),
        _buildStepRow(
          "2. Bawa ke bank sampah\nterdekat. ",
          "lib/assets/imgs/step2.png",
          isImageFirst: false,
        ),
        const Divider(),
        _buildStepRow(
          "3. Sampah akan ditimbang,\ndan poin akan ditambahkan\nke akun Anda sesuai jumlah\nsampah yang Anda\nserahkan.",
          "lib/assets/imgs/step3.png",
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildStepRow(String text, String imagePath,
      {bool isImageFirst = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isImageFirst
            ? [
                Text(text, style: GoogleFonts.dmSans(fontSize: 14)),
                Image.asset(imagePath, height: 65, width: 65),
              ]
            : [
                Image.asset(imagePath, height: 65, width: 65),
                Text(text, style: GoogleFonts.dmSans(fontSize: 14)),
              ],
      ),
    );
  }
}
