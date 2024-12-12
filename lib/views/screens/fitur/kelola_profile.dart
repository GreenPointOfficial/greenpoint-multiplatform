import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/models/user_model.dart';
import 'package:greenpoint/service/auth_service.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class KelolaProfilePage extends StatefulWidget {
  const KelolaProfilePage({Key? key}) : super(key: key);

  @override
  _KelolaProfilePageState createState() => _KelolaProfilePageState();
}

class _KelolaProfilePageState extends State<KelolaProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _joinController;

  UserModel? _userData;
  bool _isLoading = true;
  bool _hasChanges = false;
  File? _imageFile;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final AuthService _authService = AuthService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _joinController = TextEditingController();

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        print("Token tidak ditemukan atau kosong.");
        setState(() => _isLoading = false);
        return;
      }

      final userData = await _authService.userData(token);

      if (userData == null) {
        print("Data user kosong.");
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
      _userData = userData;
      _nameController.text = userData.name ?? 'Not Available';
      _emailController.text = userData.email ?? 'Not Available';

      DateTime? joinDate = userData.createdAt != null
          ? DateTime.tryParse(userData.createdAt!)
          : null;

      _joinController.text = joinDate != null
          ? DateFormat('yyyy-MM-dd').format(joinDate)
          : 'Not Available';

      _isLoading = false;
    });

      // Tambahkan listener untuk mendeteksi perubahan pada nama
      _nameController.addListener(() {
        _checkChanges();
      });
    } catch (e) {
      print("Error saat mengambil data user: $e");
      setState(() => _isLoading = false);
    }
  }

  void _checkChanges() {
    bool nameChanged = _nameController.text != (_userData?.name ?? '');
    setState(() {
      _hasChanges = nameChanged || _imageFile != null;
    });
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Ambil Foto'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
  try {
    // Pick an image from the gallery or camera
    final pickedFile = await _imagePicker.pickImage(source: source);

    // Check if an image is picked
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);  // Save the picked image to _imageFile
        _checkChanges();  // Your function to handle any logic after the image is picked
      });
    } else {
      // Toast message if no image is selected
      Fluttertoast.showToast(
        msg: "No image selected",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  } catch (e) {
    // Catch any errors during image picking
    print('Error picking image: $e');
    Fluttertoast.showToast(
      msg: "Failed to pick image. Please try again.",
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}

  Future<void> _updateUserProfile({String? imagePath}) async {
    try {
      String? token = await _secureStorage.read(key: 'auth_token');
      String updatedName = _nameController.text;
      print('ini $updatedName');

      if (updatedName.isEmpty) {
        Fluttertoast.showToast(
          msg: "Nama tidak boleh kosong",
          toastLength: Toast.LENGTH_SHORT,
        );
        return;
      }

      // Only proceed if there are changes
      if (!_hasChanges) {
        Fluttertoast.showToast(
          msg: "Tidak ada perubahan untuk disimpan",
          toastLength: Toast.LENGTH_SHORT,
        );
        return;
      }

      var response = await _authService.updateUserData(
        token: token,
        name: updatedName,
        password: null, 
        imagePath: imagePath,
      );

      if (response != null) {
        setState(() {
          _userData = response;
          _nameController.text = _userData?.name ?? '';
          
          _imageFile = null; 
          _hasChanges = false;
        });

        Fluttertoast.showToast(
          msg: "Profil berhasil diperbarui",
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Gagal memperbarui profil",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      Fluttertoast.showToast(
        msg: "Gagal memperbarui profil: $e",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _joinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(
        title: "Kelola Profile",
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: GreenPointColor.secondary,
            ))
          : Padding(
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hasChanges
                              ? GreenPointColor.secondary
                              : GreenPointColor.abu,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _hasChanges
                            ? () {
                                _updateUserProfile(imagePath: _imageFile?.path);
                              }
                            : null,
                        child: const Text(
                          "Simpan perubahan",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
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
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : const AssetImage("lib/assets/imgs/profile_placeholder.jpg")
                  as ImageProvider,
        ),
        InkWell(
          onTap: _showImagePickerBottomSheet,
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
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: GreenPointColor.secondary),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: GreenPointColor.abu),
              )),
          controller: controller,
          enabled: input,
          style: GoogleFonts.dmSans(
              fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
