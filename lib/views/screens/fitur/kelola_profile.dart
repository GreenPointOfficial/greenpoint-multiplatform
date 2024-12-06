import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class KelolaProfilePage extends StatefulWidget {
  const KelolaProfilePage({Key? key}) : super(key: key);

  @override
  _KelolaProfilePageState createState() => _KelolaProfilePageState();
}

class _KelolaProfilePageState extends State<KelolaProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _joinController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserData();
    DateTime? joinDate = userProvider.bergabungSejak != null
        ? DateTime.tryParse(
            userProvider.bergabungSejak) // Mengonversi string ke DateTime
        : null;

    String formattedJoinDate = joinDate != null
        ? DateFormat('yyyy-MM-dd').format(joinDate)
        : 'Not Available';

    _joinController = TextEditingController(text: formattedJoinDate);
    _nameController = TextEditingController(text: userProvider.userName);
    _emailController = TextEditingController(text: userProvider.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _joinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(title: "Kelola Profile"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _buildAvatarWithEditButton(),
                const SizedBox(height: 20),
                _buildText("Nama", _nameController, true),
                _buildText("Email", _emailController, false),
                _buildText("Bergabung Sejak", _joinController, false),
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
      ),
    );
  }

  Widget _buildAvatarWithEditButton() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              const AssetImage("lib/assets/imgs/profile_placeholder.jpg"),
        ),
        InkWell(
          onTap: () {
            // Logic to edit photo
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GreenPointColor.abu,
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText(
      String label, TextEditingController controller, bool input) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black54),
        ),
        TextField(
          decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: GreenPointColor.secondary),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: GreenPointColor.abu),
              )),
          controller: controller,
          enabled: input,

          style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black), // Disables input
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
