import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/auth_controller.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/service/auth_service.dart';
import 'package:greenpoint/views/screens/auth/daftar_page.dart';
import 'package:greenpoint/views/screens/fitur/beranda.dart';
import 'package:greenpoint/views/widget/input_widget.dart';
import 'package:greenpoint/views/widget/welcome_widget.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final AuthController _authController = AuthController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isRememberMe = false;
  bool isLoading = false;
  String? notificationMessage;
  Color notificationColor = Colors.transparent;
  Color notificationTextColor = Colors.black;

  final AuthService _authService = AuthService();
  final UserProvider _userProvider = UserProvider();
  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    final rememberedEmail = await _secureStorage.read(key: 'remembered_email');
    final rememberedPassword =
        await _secureStorage.read(key: 'remembered_password');

    if (rememberedEmail != null && rememberedPassword != null) {
      setState(() {
        emailController.text = rememberedEmail;
        passwordController.text = rememberedPassword;
        _isRememberMe = true;
      });
    }
  }

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
  // Validasi input
  if (email.isEmpty || password.isEmpty) {
    if (mounted) {
      setState(() {
        notificationMessage = "Semua kolom harus diisi!";
        notificationColor = Colors.white;
        notificationTextColor = Colors.red;
      });
    }
    return;
  }

  // Tampilkan indikator loading
  setState(() {
    isLoading = true;
  });

  try {
    // Lakukan request login ke server
    final response = await _authController.loginUser(email, password);
    print("Login response: $response");

    if (!mounted) return; // Pastikan widget masih aktif

    // Cek apakah login berhasil
    if (response['success'] == true) {
      // Ambil token dari response
      String token = response['token'];
      print("Token received: $token");

      // Simpan token menggunakan UserProvider
      // await _userProvider.saveToken(token);
      await Future.delayed(Duration(milliseconds: 100)); // Delay opsional
      await _userProvider.readToken();

      // Ambil data user dari response
      final userData = response['user_data'] ?? {};
      if (userData.isNotEmpty) {
        // Simpan data user ke UserProvider
        _userProvider.setUser(userData, response['token']);
        print("User data saved: $userData");
      } else {
        print("No user data found in response!");
      }

      // Simpan email dan password jika 'Remember Me' diaktifkan
      if (_isRememberMe) {
        await _secureStorage.write(key: 'remembered_email', value: email);
        await _secureStorage.write(key: 'remembered_password', value: password);
      } else {
        await _secureStorage.delete(key: 'remembered_email');
        await _secureStorage.delete(key: 'remembered_password');
      }

      // Tampilkan notifikasi keberhasilan login
      setState(() {
        notificationMessage = "Login berhasil!";
        notificationColor = Colors.white;
        notificationTextColor = GreenPointColor.primary;
      });

      // Navigasi ke halaman utama (Beranda)
      if (_authController.fetchUserProfile() != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Beranda()),
        );
      } else {
        showNotification(
          "Autentikasi gagal. Silakan coba lagi.",
          Colors.white,
          Colors.red,
        );
      }
    } else {
      // Tampilkan notifikasi kegagalan login
      setState(() {
        notificationMessage =
            response['message'] ?? "Login gagal. Silakan coba lagi.";
        notificationColor = Colors.white;
        notificationTextColor = Colors.red;
      });
    }
  } catch (e) {
    // Tangani error jika terjadi masalah
    print("Login error: $e");
    if (mounted) {
      setState(() {
        notificationMessage = "Terjadi kesalahan. Silakan coba lagi.";
        notificationColor = Colors.white;
        notificationTextColor = Colors.red;
      });
    }
  } finally {
    // Sembunyikan indikator loading
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  Future<void> handleGoogleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _authController.handleGoogleLogin();

      if (response['success']) {
        // Simpan data user dari response ke UserProvider
        final userData = response['user_data'];
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userData, response['token']);

        // Clear any stored credentials for "Remember Me"
        await _secureStorage.delete(key: 'remembered_email');
        await _secureStorage.delete(key: 'remembered_password');

        showNotification(
          "Google login berhasil!",
          Colors.white,
          GreenPointColor.primary,
        );

        // Navigasi ke halaman Beranda
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
    } catch (e) {
      print('Google login error: $e');
      showNotification(
        "Google login gagal. Terjadi kesalahan.",
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
              top: screenHeight * 0.45,
              left: (screenWidth - (screenWidth * 0.85)) / 2,
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
                    color: notificationTextColor,
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
