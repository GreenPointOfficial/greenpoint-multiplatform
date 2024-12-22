import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/views/screens/auth/masuk_page.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';
import 'package:provider/provider.dart';

class UbahSandi extends StatefulWidget {
  const UbahSandi({Key? key}) : super(key: key);

  @override
  _UbahSandiState createState() => _UbahSandiState();
}

class _UbahSandiState extends State<UbahSandi> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUserData();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  Future<void> _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi password tidak cocok")),
      );
      return;
    }

    try {
      final response = await UserProvider().updatePassword(oldPassword, newPassword);

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MasukPage()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password berhasil diubah!")),
        );

        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        String errorMessage = 'Gagal mengubah password';
        
        try {
          var responseBody = json.decode(response.body);
          errorMessage = responseBody['message'] ?? errorMessage;
        } catch (e) {
          // Jika parsing gagal, gunakan pesan default
          errorMessage = 'Gagal mengubah password: ${response.statusCode}';
        }

        // Tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Tangani error jaringan atau exception lainnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Appbar2Widget(title: "Mengubah Password"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _oldPasswordController,
                label: "Password Lama",
                isObscure: _isObscureOld,
                toggleObscure: () => setState(() => _isObscureOld = !_isObscureOld),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password lama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _newPasswordController,
                label: "Password Baru",
                isObscure: _isObscureNew,
                toggleObscure: () => setState(() => _isObscureNew = !_isObscureNew),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password baru tidak boleh kosong";
                  } else if (value.length < 8) {
                    return "Password harus terdiri dari minimal 8 karakter";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: "Konfirmasi Password Baru",
                isObscure: _isObscureConfirm,
                toggleObscure: () => setState(() => _isObscureConfirm = !_isObscureConfirm),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Konfirmasi Password tidak boleh kosong";
                  } else if (value != _newPasswordController.text) {
                    return "Konfirmasi Password tidak cocok";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword(); // Call the function to update password
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFF1A3C40),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isObscure,
    required VoidCallback toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: GreenPointColor.secondary, width: 2),
        ),
        labelText: label,
        labelStyle: TextStyle(color: GreenPointColor.secondary),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleObscure,
        ),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    // Pastikan untuk melepas controller saat widget di-dispose
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}