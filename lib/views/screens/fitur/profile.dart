import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/models/user_model.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/service/auth_service.dart';
import 'package:greenpoint/views/screens/auth/masuk_page.dart';
import 'package:greenpoint/views/screens/fitur/kelola_profile.dart';
import 'package:greenpoint/views/screens/fitur/pengaturan.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAboutExpanded = false;
  bool isFAQExpanded = false;
  UserModel? _userData;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    if (Provider.of<UserProvider>(context, listen: false).userName.isEmpty) {
      Provider.of<UserProvider>(context, listen: false).fetchUserData();
    }
    _fetchUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserData(); // Muat ulang data ketika kembali ke halaman ini
  }

  Future<void> _fetchUserData() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token != null) {
        final userData = await _authService.userData(token);
        setState(() {
          _userData = userData;
        });
      } else {
        throw Exception('Token not found');
      }
    } catch (e) {
      // Show error or handle appropriately
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(title: "Profile", hideLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 15),
              _buildProfileOption(
                "Kelola Profile",
                Icons.person_outline,
                Colors.black,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KelolaProfilePage()),
                ),
              ),
              Divider(),
              _buildProfileOption(
                  "Pengaturan",
                  Icons.settings_outlined,
                  Colors.black,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PengaturanPage()),
                      )),
              if (!isAboutExpanded) Divider(),
              _buildExpandableAbout(
                "Tentang kami",
                Icons.info_outline,
              ),
              if (!isFAQExpanded) Divider(),
              _buildExpandableFAQs(),
              if (!isFAQExpanded) Divider(),
              _buildProfileOption(
                "Keluar",
                Icons.logout,
                Colors.red,
                _showLogoutConfirmation,
              ),
              Divider(),
              const SizedBox(height: 50),
              Text(
                "Version 1.0.0",
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final userName = Provider.of<UserProvider>(context).userName;
    final email = Provider.of<UserProvider>(context).email;

    return Row(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: (_userData?.fotoProfil != null
                ? NetworkImage(_userData!.fotoProfil!)
                : const AssetImage("lib/assets/imgs/profile_placeholder.jpg")
                    as ImageProvider),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName,
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500, fontSize: 16)),
            Text(email, style: GoogleFonts.dmSans(fontWeight: FontWeight.w300)),
          ],
        )
      ],
    );
  }

  Widget _buildProfileOption(
      String title, IconData icon, Color color, VoidCallback callback) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16, bottom: 16, right: 25.0, left: 15),
      child: GestureDetector(
        onTap: callback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24.0),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Icon(Icons.keyboard_arrow_right, color: color, size: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableAbout(
    String title,
    IconData icon,
  ) {
    return ExpansionTile(
      initiallyExpanded: isAboutExpanded,
      onExpansionChanged: (bool expanded) {
        setState(() {
          isAboutExpanded = expanded;
        });
      },
      leading: Icon(icon, color: Colors.black, size: 24.0),
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black),
              children: [
                TextSpan(
                  text: "Green",
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: GreenPointColor.primary),
                ),
                TextSpan(
                  text: "Point",
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GreenPointColor
                        .orange, // Tambahkan warna hijau untuk penekanan
                  ),
                ),
                TextSpan(
                    text:
                        " adalah aplikasi ramah lingkungan yang membantu mengelola limbah menjadi lebih bernilai. "
                        "Kami bertujuan untuk meningkatkan kesadaran akan daur ulang dengan memberikan insentif berupa poin "
                        "yang dapat ditukar menjadi saldo e-wallet.",
                    style: GoogleFonts.dmSans(
                        fontSize: 12, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ],
      trailing: Icon(
        isAboutExpanded
            ? Icons.keyboard_arrow_down
            : Icons.keyboard_arrow_right,
        color: Colors.black,
        size: 25.0,
      ),
    );
  }

  Widget _buildExpandableFAQs() {
    return ExpansionTile(
      initiallyExpanded: isFAQExpanded,
      onExpansionChanged: (bool expanded) {
        setState(() {
          isFAQExpanded = expanded;
        });
      },
      leading:
          Icon(Icons.question_answer_outlined, color: Colors.black, size: 24.0),
      title: Text(
        "FAQs",
        style: GoogleFonts.dmSans(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        isFAQExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
        color: Colors.black,
        size: 25.0,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFAQItem(
                "Apa itu GreenPoint?",
                "GreenPoint adalah aplikasi yang memungkinkan Anda menukar sampah dengan poin yang bisa dicairkan menjadi saldo e-wallet atau uang tunai.",
              ),
              _buildFAQItem(
                "Bagaimana cara menukar poin?",
                "Anda bisa mengumpulkan sampah dan membawanya ke bank sampah terdaftar atau tempat pengumpulan akhir. Sampah akan ditimbang, dan poin akan ditambahkan ke akun Anda sesuai jumlah sampah yang Anda serahkan.",
              ),
              _buildFAQItem(
                "Di mana lokasi bank sampah terdekat?",
                "Anda dapat menemukan lokasi bank sampah terdekat di menu Lokasi di dalam aplikasi. Fitur ini akan menampilkan bank sampah berdasarkan jarak dari lokasi Anda.",
              ),
              _buildFAQItem(
                "Bagaimana cara menukarkan poin menjadi saldo e-wallet?",
                "Masuk ke menu Penukaran Poin, pilih e-wallet yang diinginkan, dan ikuti instruksi untuk menukarkan poin menjadi saldo.",
              ),
              _buildFAQItem(
                "Apakah ada biaya untuk menggunakan aplikasi ini?",
                "GreenPoint sepenuhnya gratis digunakan. Tidak ada biaya yang dikenakan untuk pendaftaran atau penggunaan fitur dasar aplikasi.",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: Icon(Icons.question_mark_sharp, color: Colors.black),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: GoogleFonts.dmSans(
                fontSize: 12, color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
      ],
      trailing: Icon(
        isFAQExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
        color: Colors.black,
        size: 25.0,
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(children: [
            Text(
              'Konfirmasi Keluar',
              style:
                  GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ]),
          content: Container(
              height: 70,
              child: Column(
                children: [
                  Divider(),
                  Text(
                    textAlign: TextAlign.center,
                    'Apakah anda yakin ingin keluar?',
                    style: GoogleFonts.dmSans(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0), // Explicit padding
                    maximumSize: Size(100, 42),
                    minimumSize:
                        Size(100, 42), // Ensure both buttons have the same size
                    backgroundColor: GreenPointColor.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Tidak',
                    style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      // width: 3.0,
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0), // Explicit padding
                    // backgroundColor: Colors.red,

                    maximumSize: Size(100, 42),
                    minimumSize:
                        Size(100, 42), // Ensure both buttons have the same size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await Provider.of<UserProvider>(context, listen: false)
                        .logout();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MasukPage()),
                    );
                  },
                  child: Text(
                    'Ya',
                    style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
