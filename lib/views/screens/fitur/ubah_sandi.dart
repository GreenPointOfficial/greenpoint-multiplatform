import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/widget/appbar2_widget.dart';

class UbahSandi extends StatefulWidget {
  const UbahSandi({Key? key}) : super(key: key);

  @override
  _UbahSandiState createState() => _UbahSandiState();
}

class _UbahSandiState extends State<UbahSandi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

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
                controller: _newPasswordController,
                label: "Password Baru",
                isObscure: _isObscureNew,
                toggleObscure: () => setState(() => _isObscureNew = !_isObscureNew),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password baru tidak boleh kosong";
                  } else if (value.length < 6) {
                    return "Password harus terdiri dari minimal 6 karakter";
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password berhasil diubah!")),
                      );
                      _oldPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFF1A3C40),
                  ),
                  child:  const Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
}
