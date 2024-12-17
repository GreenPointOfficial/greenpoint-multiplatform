import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greenpoint/controllers/artikel_controller.dart';
import 'package:greenpoint/controllers/dampak_controller.dart';
import 'package:greenpoint/controllers/daur_ulang_controller.dart';
import 'package:greenpoint/controllers/lokasi_controller.dart';
import 'package:greenpoint/controllers/payout_controller.dart';
import 'package:greenpoint/controllers/penjualan_controller.dart';
import 'package:greenpoint/providers/notifikasi_provider.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:greenpoint/controllers/jenis_sampah_controller.dart';
import 'package:greenpoint/views/screens/fitur/splash.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSignIn().isSignedIn();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotifikasiProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PayoutController()),
        ChangeNotifierProvider(create: (_) => JenisSampahController()),
        ChangeNotifierProvider(create: (_) => DampakController()),
        ChangeNotifierProvider(create: (_) => DaurUlangController()),
        ChangeNotifierProvider(create: (_) => ArtikelController()),
        ChangeNotifierProvider(create: (_) => PenjualanController()),
        ChangeNotifierProvider(create: (_) => LokasiController()),
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
