import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:provider/provider.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  _PengaturanPageState createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  String _selectedLanguage = 'id'; // Default language is 'id'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(title: "Pengaturan"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildProfileOption(
              "Mengubah Sandi",
              Icons.key,
              Colors.black,
              () => {},
            ),
            _buildLanguageSwitchOption(),
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
            image: const DecorationImage(
              image: AssetImage("lib/assets/imgs/profile_placeholder.jpg"),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName,
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w500)),
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

  // Widget untuk opsi beralih bahasa
  Widget _buildLanguageSwitchOption() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16, bottom: 16, right: 25.0, left: 15),
      child: GestureDetector(
        onTap: () {
          _showLanguageDialog();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.translate,
                  color: Colors.black,
                  size: 24.0,
                ),
                const SizedBox(width: 12),
                Text(
                  "Beralih bahasa",
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol untuk bahasa Indonesia (ID)
                Container(
                  height: 30,
                  width: 40,
                  decoration: BoxDecoration(
                    color: GreenPointColor.primary, // Warna aktif untuk ID
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'ID',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Warna non-aktif untuk EN
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'EN',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dialog untuk memilih bahasa
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Pilih Bahasa",
            style:
                GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  "Bahasa Indonesia",
                  style: GoogleFonts.dmSans(fontSize: 14),
                ),
                leading: Icon(Icons.language),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'id';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  "English",
                  style: GoogleFonts.dmSans(fontSize: 14),
                ),
                leading: Icon(Icons.language),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'en';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
