import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/controllers/auth_controller.dart';
import 'package:greenpoint/service/auth_service.dart';
import 'package:greenpoint/views/screens/auth/daftar_page.dart';
import 'package:greenpoint/views/screens/fitur/beranda.dart';
import 'package:greenpoint/views/widget/input_widget.dart';
import 'package:greenpoint/views/widget/welcome_widget.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final AuthController _authController = AuthController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isRememberMe = false;
  bool isLoading = false;
  String? notificationMessage;
  Color notificationColor = Colors.transparent;
  Color notificationTextColor = Colors.black;

  final AuthService _authService = AuthService();

  void showNotification(String message, Color bgColor, Color textColor) {
    setState(() {
      notificationMessage = message;
      notificationColor = bgColor;
      notificationTextColor = textColor;
    });

    // Hide notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        notificationMessage = null;
        notificationColor = Colors.transparent;
        notificationTextColor = Colors.black;
      });
    });
  }

  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showNotification(
        "Semua kolom harus diisi!",
        Colors.white,
        Colors.red,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Call the AuthController's login method
    final response = await _authController.loginUser(email, password);

    if (response['success']) {
      showNotification(
        "Login berhasil!",
        Colors.white,
        GreenPointColor.primary,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Beranda()),
      );
    } else {
      showNotification(
        response['message'] ?? "Login gagal. Silakan coba lagi.",
        Colors.white,
        Colors.red,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> handleGoogleLogin() async {
    setState(() {
      isLoading = true;
    });

    final response = await _authController.handleGoogleLogin();

    if (response['success']) {
      showNotification(
        "Google login berhasil!",
        Colors.white,
        GreenPointColor.primary,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Beranda()),
      );
    } else {
      showNotification(
        response['message'] ?? "Google login gagal.",
        Colors.white,
        Colors.red,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              SizedBox(
                width: screenWidth,
                child: Image.asset(
                  'lib/assets/imgs/bg_atas.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const JudulWidget(size: 36),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: screenWidth * 0.85,
                child: InputWidget(
                  hintText: 'Email',
                  hintTextColor: Colors.white,
                  textColor: Colors.white,
                  fillColor: GreenPointColor.abu,
                  icon: Icons.email,
                  controller: emailController,
                ),
              ),
              // SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: screenWidth * 0.85,
                child: InputWidget(
                  hintText: 'Password',
                  hintTextColor: Colors.white,
                  textColor: Colors.white,
                  fillColor: GreenPointColor.abu,
                  icon: Icons.lock,
                  isPassword: true,
                  controller: passwordController,
                ),
              ),
              // SizedBox(height: screenHeight * 0.02),s
              Container(
                width: screenWidth * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AnimatedOpacity(
                          opacity: _isRememberMe ? 1.0 : 0.5,
                          duration: Duration(milliseconds: 300),
                          child: Checkbox(
                            value: _isRememberMe,
                            onChanged: (value) {
                              setState(() {
                                _isRememberMe = value!;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            side: BorderSide(color: Colors.grey),
                            activeColor: Colors.white,
                            checkColor: GreenPointColor.primary,
                          ),
                        ),
                        Text(
                          "Ingat saya",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 12),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Aksi ketika teks "Lupa kata sandi?" diklik
                      },
                      child: Text(
                        "Lupa kata sandi?",
                        style: GoogleFonts.poppins(
                            color: GreenPointColor.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: screenHeight * 0.02),
              isLoading
                  ? CircularProgressIndicator(
                      color: GreenPointColor.primary,
                    )
                  : SizedBox(
                      width: screenWidth * 0.85,
                      child: TombolWidget(
                        warna: GreenPointColor.secondary,
                        warnaText: Colors.white,
                        text: "Masuk",
                        onPressed: () => loginUser(
                            emailController.text, passwordController.text),
                      ),
                    ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: "Belum punya akun? ",
                          style: GoogleFonts.inter(
                              color: GreenPointColor.abu, fontSize: 11)),
                      TextSpan(
                          text: "Daftar",
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: GreenPointColor.primary,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DaftarPage()))),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
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
              SizedBox(height: screenHeight * 0.02),
              isLoading
                  ? CircularProgressIndicator(color: GreenPointColor.primary)
                  : TombolWidget(
                      warna: Colors.white,
                      warnaText: Colors.black,
                      text: "Google",
                      onPressed: () => handleGoogleLogin(),
                      width: screenWidth * 0.85,
                      assetIcon: "lib/assets/imgs/google.png",
                    )
            ],
          ),
          // Notifikasi ditempatkan di atas layout
          if (notificationMessage != null)
            Positioned(
              top: screenHeight *
                  0.45, // Atur jarak dari atas (bawah JudulWidget)
              left: (screenWidth - (screenWidth * 0.85)) /
                  2, // Pusatkan notifikasi
              child: Container(
                width: screenWidth * 0.85,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  notificationMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: notificationTextColor, // Text color
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
