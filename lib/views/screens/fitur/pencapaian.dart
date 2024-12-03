import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:provider/provider.dart';
import 'package:greenpoint/controllers/penjualan_controller.dart';

class PencapaianPage extends StatefulWidget {
  const PencapaianPage({Key? key}) : super(key: key);

  @override
  _PencapaianPageState createState() => _PencapaianPageState();
}

class _PencapaianPageState extends State<PencapaianPage> {
  int? currentProgress;
  int? bonus;
  final _storage = const FlutterSecureStorage();

  // Milestone configurations
  final List<Map<String, dynamic>> _milestones = [
    {
      'weight': 10,
      'bonus': 100000,
      'message':
          'Selamat! Anda mendapatkan bonus karena telah menyelesaikan penjualan 10Kg sampah.'
    },
    {
      'weight': 30,
      'bonus': 150000,
      'message':
          'Selamat! Anda mendapatkan bonus karena telah menyelesaikan penjualan 30Kg sampah.'
    },
    {
      'weight': 50,
      'bonus': 200000,
      'message':
          'Selamat! Anda mendapatkan bonus karena telah menyelesaikan penjualan 50Kg sampah.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkAndResetMilestones();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final penjualanController =
          Provider.of<PenjualanController>(context, listen: false);
      penjualanController.getUserPercentage();
    });
  }

  Future<void> _checkAndResetMilestones() async {
    // Get the last reset date
    String? lastResetDateString =
        await _storage.read(key: 'milestones_reset_date');

    if (lastResetDateString != null) {
      DateTime lastResetDate = DateTime.parse(lastResetDateString);
      DateTime now = DateTime.now();

      // If it's been more than a month, reset all milestone claims
      if (now.difference(lastResetDate).inDays >= 30) {
        // Remove all existing milestone claim records
        for (var milestone in _milestones) {
          await _storage.delete(
              key: 'milestone_${milestone['weight']}kg_claimed');
        }

        // Update reset date
        await _storage.write(
            key: 'milestones_reset_date', value: now.toIso8601String());
      }
    } else {
      // If no reset date exists, set it to current date
      await _storage.write(
          key: 'milestones_reset_date',
          value: DateTime.now().toIso8601String());
    }
  }

  Future<bool> _checkMilestoneEligibility(int weight) async {
    String key = 'milestone_${weight}kg_claimed';
    String? claimedValue = await _storage.read(key: key);
    return claimedValue == null;
  }

  Future<void> _markMilestoneClaimed(int weight) async {
    String key = 'milestone_${weight}kg_claimed';
    await _storage.write(key: key, value: 'true');
  }

  @override
  Widget build(BuildContext context) {
    final penjualanController = Provider.of<PenjualanController>(context);
    bonus = penjualanController.bonus;

    // Update user points

    currentProgress = penjualanController.userPercentage;

    // Check and potentially show milestone dialogs
    _checkMilestones(currentProgress);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar2Widget(title: "Pencapaian"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.screenWidth(context) * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Reward Bulanan"),
              _buildRewardContainer(context, currentProgress),
              Container(
                alignment: Alignment.center,
                child: _buildSectionTitle("Cara Menjual Sampah"),
              ),
              _buildStepsSection(),
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                child: Text(
                  "Bersama kita wujudkan perubahan kecil yang berdampak besar bagi bumi.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: ScreenUtils.screenWidth(context) * 0.035,
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _checkMilestones(int? progress) async {
  // Pastikan progress tidak null dan minimal 10
  if (progress == null || progress < 10) return;

  // Cek setiap milestone
  for (var milestone in _milestones) {
    if (progress >= milestone['weight']) {
      bool isEligible = await _checkMilestoneEligibility(milestone['weight']);
      if (isEligible) {
        // Tambahkan bonus ke poin pengguna
        int currentPoin = Provider.of<UserProvider>(context, listen: false).poin;
        Provider.of<UserProvider>(context, listen: false)
            .autoRefreshUserData({
          'poin': currentPoin + milestone['bonus'],
        });

        // Tampilkan dialog
        _showDialog(
          "Selamat!",
          milestone['message'],
          achievedWeight: milestone['weight'],
          bonus: milestone['bonus'],
        );

        // Tandai milestone telah dicapai
        await _markMilestoneClaimed(milestone['weight']);
      }
    }
  }
}
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtils.screenHeight(context) * 0.015),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
          fontSize: ScreenUtils.screenWidth(context) * 0.04,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRewardContainer(BuildContext context, int? currentProgress) {
    return Container(
      width: ScreenUtils.screenWidth(context),
      decoration: BoxDecoration(
        color: GreenPointColor.secondary,
        border: Border.all(),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils.screenWidth(context) * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRewardText("Ayo selamatkan bumi\ndan dapatkan "),
            _buildPointRow("450.000"),
            const Divider(color: Colors.white),
            SizedBox(height: ScreenUtils.screenHeight(context) * 0.01),
            _buildSubTitle("Penjualan anda:"),
            SizedBox(height: ScreenUtils.screenHeight(context) * 0.01),
            _buildProgressBar(context, currentProgress),
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
        fontSize: ScreenUtils.screenWidth(context) * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPointRow(String points) {
    return Row(
      children: [
        Image.asset("lib/assets/imgs/poin.png",
            height: ScreenUtils.screenWidth(context) * 0.06),
        SizedBox(width: ScreenUtils.screenWidth(context) * 0.02),
        Text(
          points,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtils.screenWidth(context) * 0.05,
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
        fontSize: ScreenUtils.screenWidth(context) * 0.035,
        color: Colors.white,
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, int? progress) {
    double progressWidth = (progress ?? 0) / 100;

    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: ScreenUtils.screenHeight(context) * 0.015,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Container(
              height: ScreenUtils.screenHeight(context) * 0.015,
              width: ScreenUtils.screenWidth(context) * progressWidth,
              decoration: BoxDecoration(
                color: GreenPointColor.orange,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Positioned(
              left: ScreenUtils.screenWidth(context) * 0.4,
              child: Text(
                "${(progressWidth * 100).toStringAsFixed(0)}%",
                style: GoogleFonts.dmSans(
                  fontSize: ScreenUtils.screenWidth(context) * 0.03,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtils.screenHeight(context) * 0.01),
      ],
    );
  }

  Widget _buildMilestones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMilestone("10Kg", "100.000"),
        _buildMilestone("30Kg", "150.000"),
        _buildMilestone("50Kg", "200.000"),
      ],
    );
  }

  Widget _buildMilestone(String weight, String points) {
    return Column(
      children: [
        Text(
          weight,
          style: GoogleFonts.dmSans(
              fontSize: ScreenUtils.screenWidth(context) * 0.03,
              color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("lib/assets/imgs/poin.png",
                height: ScreenUtils.screenWidth(context) * 0.03),
            SizedBox(width: ScreenUtils.screenWidth(context) * 0.01),
            Text(
              points,
              style: GoogleFonts.dmSans(
                fontSize: ScreenUtils.screenWidth(context) * 0.03,
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

  void _showDialog(String title, String message,
      {required int achievedWeight, required int bonus}) {
    Future.microtask(() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(
                  bonus > 0 ? Icons.check_circle_outline : Icons.error_outline,
                  color: bonus > 0 ? Colors.green : Colors.red,
                  size: 30,
                ),
                const Divider(),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: bonus > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFFF6FAFD),
                        ),
                        child: Image.asset(
                          'lib/assets/imgs/poin.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$bonus points',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                Text(
                  textAlign: TextAlign.center,
                  message,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Text(
                      'Tutup',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
