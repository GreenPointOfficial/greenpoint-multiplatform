import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(title: "Register", title2: "Buat akun barumu"),
      body: Center(
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
                controller: usernameController,
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
            SizedBox(
              width: ScreenUtils.screenWidth(context) * 0.85,
              child: TombolWidget(
                warna: GreenPointColor.secondary,
                warnaText: Colors.white,
                text: "Daftar",
                onPressed: () {},
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
                      "Atau daftar dengan",
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
              onPressed: () {},
              width: ScreenUtils.screenWidth(context) * 0.85,
              assetIcon: "lib/assets/imgs/google.png",
            ),
            SizedBox(height: ScreenUtils.screenHeight(context) * 0.02),
            Expanded(
              child: ClipRect(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  // heightFactor:
                  //     1, // Adjust this value to control the crop height from the bottom
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
    );
  }
}
