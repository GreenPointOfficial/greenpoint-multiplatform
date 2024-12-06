import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:provider/provider.dart';

class KelolaProfilePage extends StatefulWidget {
  const KelolaProfilePage({Key? key}) : super(key: key);

  @override
  _KelolaProfilePageState createState() => _KelolaProfilePageState();
}

class _KelolaProfilePageState extends State<KelolaProfilePage> {
  // late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserData();
    // _nameController = TextEditingController(text: userProvider.userName);
  }

  @override
  void dispose() {
    // _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
            // Logika untuk mengedit foto
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
}
