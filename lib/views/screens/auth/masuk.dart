import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/views/widget/input_widget.dart';
import 'package:greenpoint/views/widget/judul_widget.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class MasukPage extends StatefulWidget {
  const MasukPage({super.key});

  @override
  State<MasukPage> createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isRememberMe = false; // Added to track checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: ScreenUtils.screenWidth(context), // Using utility class
                child: Image.asset(
                  'lib/assets/imgs/bg_atas.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: ScreenUtils.screenHeight(context) * 0.02),
              const JudulWidget(size: 36),
              SizedBox(height: ScreenUtils.screenHeight(context) * 0.03),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.85, // Adjust as needed
                child: InputWidget(
                  hintText: 'Username',
                  hintTextColor: Colors.white,
                  textColor: Colors.white,
                  fillColor: GreenPointColor.abu,
                  icon: Icons.person,
                  controller: emailController,
                ),
              ),
              SizedBox(
                width: ScreenUtils.screenWidth(context) * 0.85,
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
                width: ScreenUtils.screenWidth(context) * 0.85,
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
              SizedBox(height: ScreenUtils.screenHeight(context) * 0.01),
              SizedBox(
                  width: ScreenUtils.screenWidth(context) * 0.85,
                  child: TombolWidget(
                      warna: GreenPointColor.secondary,
                      warnaText: Colors.white,
                      text: "Masuk",
                      onPressed: () {})),
              SizedBox(height: ScreenUtils.screenHeight(context) * 0.01),
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
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: GreenPointColor.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ScreenUtils.screenHeight(context) * 0.02),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: GreenPointColor.abu,
                        thickness: 1.5,
                        indent: 20, // Optional: adds spacing at the start
                        endIndent: 10, // Optional: adds spacing before the text
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
                        indent: 10, // Optional: adds spacing after the text
                        endIndent: 20, // Optional: adds spacing at the end
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
