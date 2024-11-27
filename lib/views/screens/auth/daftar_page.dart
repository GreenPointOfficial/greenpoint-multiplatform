import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/controllers/auth_controller.dart';
import 'package:greenpoint/views/screens/auth/masuk_page.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:greenpoint/views/widget/input_widget.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  _DaftarPageState createState() => _DaftarPageState();
}
class _DaftarPageState extends State<DaftarPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = AuthController();
  bool isLoading = false;
  String? notificationMessage; // Untuk menyimpan pesan notifikasi
  Color notificationColor = Colors.transparent; // Warna notifikasi

  void showNotification(String message, Color color) {
    setState(() {
      notificationMessage = message;
      notificationColor = color;
    });

    // Hapus pesan setelah beberapa detik
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        notificationMessage = null;
        notificationColor = Colors.transparent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const AppbarWidget(title: "Register"),
      body: Stack(
        children: [
          // Konten utama aplikasi
          Center(
            child: Column(
              children: [
                SizedBox(height: ScreenUtils.screenHeight(context) * 0.04),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: InputWidget(
                    hintText: 'Username',
                    hintTextColor: Colors.white,
                    textColor: Colors.white,
                    fillColor: GreenPointColor.abu,
                    icon: Icons.person,
                    controller: nameController,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: InputWidget(
                    hintText: 'Email',
                    hintTextColor: Colors.white,
                    textColor: Colors.white,
                    fillColor: GreenPointColor.abu,
                    icon: Icons.email,
                    controller: emailController,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: InputWidget(
                    hintText: 'Password',
                    hintTextColor: Colors.white,
                    textColor: Colors.white,
                    fillColor: GreenPointColor.abu,
                    icon: Icons.lock,
                    controller: passwordController,
                    isPassword: true,
                  ),
                ),
                SizedBox(
                  height: ScreenUtils.screenHeight(context) * 0.04,
                ),
                isLoading
                    ? CircularProgressIndicator(
                        color: GreenPointColor.primary,
                      )
                    : SizedBox(
                        width: ScreenUtils.screenWidth(context) * 0.85,
                        child: TombolWidget(
                          warna: GreenPointColor.secondary,
                          warnaText: Colors.white,
                          text: "Daftar",
                          onPressed: () async {
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              showNotification(
                                "Semua kolom harus diisi!",
                                Colors.white,
                              );
                              return;
                            }

                            if (!RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(emailController.text)) {
                              showNotification(
                                "Masukkan email yang valid!",
                                Colors.white,
                              );
                              return;
                            }

                            // Password validation
                            if (passwordController.text.length < 8) {
                              showNotification(
                                "Password harus lebih dari 8 karakter!",
                                Colors.white,
                              );
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await authController.registerUser(
                                nameController.text,
                                emailController.text,
                                passwordController.text,
                              );

                              showNotification(
                                "Pendaftaran berhasil!",
                                GreenPointColor.primary,
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MasukPage(),
                                ),
                              );
                            } catch (e) {
                              showNotification(
                                "Pendaftaran gagal: $e",
                                Colors.white,
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),
                      ),
                SizedBox(
                  height: ScreenUtils.screenHeight(context) * 0.01,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Sudah punya akun? ",
                          style: GoogleFonts.inter(
                            color: GreenPointColor.abu,
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: "Masuk",
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: GreenPointColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MasukPage(),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtils.screenHeight(context) * 0.04,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          color: GreenPointColor.abu,
                          thickness: 1.5,
                          indent: 20,
                          endIndent: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Atau masuk dengan",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: GreenPointColor.abu,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: GreenPointColor.abu,
                          thickness: 1.5,
                          indent: 10,
                          endIndent: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtils.screenHeight(context) * 0.02),
                TombolWidget(
                  warna: Colors.white,
                  warnaText: Colors.black,
                  text: 'Google',
                  onPressed: () {
                    // Your onPressed logic here
                  },
                  width: ScreenUtils.screenWidth(context) * 0.85,
                  assetIcon: "lib/assets/imgs/google.png",
                ),
                Expanded(
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'lib/assets/imgs/bg_bawah.png',
                        width: ScreenUtils.screenWidth(context),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Notifikasi yang mengambang
          if (notificationMessage != null)
            Positioned(
              top: 0, // Moved closer to the top
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: notificationMessage != null ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Slightly transparent
                    borderRadius:
                        BorderRadius.circular(6), // Slightly smaller radius
                  ),
                  child: Text(
                    notificationMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: Colors.red,
                      fontSize: 12, // Slightly smaller font
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
