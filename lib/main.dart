import 'package:flutter/material.dart';
import 'package:greenpoint/controllers/artikel_controller.dart';
import 'package:greenpoint/controllers/dampak_controller.dart';
import 'package:greenpoint/controllers/daur_ulang_controller.dart';
import 'package:provider/provider.dart';
import 'package:greenpoint/controllers/jenis_sampah_controller.dart';
import 'package:greenpoint/views/screens/fitur/splash.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JenisSampahController()),
        ChangeNotifierProvider(create: (_) => DampakController()),
        ChangeNotifierProvider(create: (_) => DaurUlangController()),
        ChangeNotifierProvider(create: (_) => ArtikelController()),
      ],
      child: const GreenPoint(),
    ),
  );
}

class GreenPoint extends StatelessWidget {
  const GreenPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenPoint',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Splash(),
    );
  }
}
