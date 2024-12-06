import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/controllers/lokasi_controller.dart';
import 'package:greenpoint/models/lokasi_model.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({Key? key}) : super(key: key);

  @override
  _LokasiPageState createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  // final PageController _pageController = PageController();
  late CameraPosition _initialCameraPosition;
  Set<Marker> _markers = {};
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _fetchLokasiData() async {
    try {
      final lokasiController =
          Provider.of<LokasiController>(context, listen: false);
      if (_currentPosition != null) {
        await lokasiController.fetchLokasi(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        if (mounted) {
          _updateMarkers(lokasiController.lokasiList);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat data lokasi: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Layanan lokasi tidak aktif");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Izin lokasi ditolak");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Izin lokasi ditolak secara permanen");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _initialCameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          );

          _markers.add(
            Marker(
              markerId: const MarkerId('current_location'),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: const InfoWindow(
                title: 'Lokasi anda',
                snippet: 'Lokasi anda saat ini!',
              ),
            ),
          );
        });

        _fetchLokasiData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mendapatkan lokasi: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateMarkers(List<LokasiModel> lokasiList) {
    setState(() {
      _markers.addAll(
        lokasiList.map((lokasi) {
          return Marker(
            markerId: MarkerId(lokasi.id.toString()),
            position: LatLng(lokasi.latitude, lokasi.longitude),
            infoWindow: InfoWindow(
              title: lokasi.namaLokasi,
              snippet: lokasi.keterangan ?? '',
            ),
          );
        }).toSet(),
      );
    });
  }

  Future<void> _launchRoute(LokasiModel lokasi) async {
    if (_currentPosition != null) {
      final String url =
          'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${lokasi.latitude},${lokasi.longitude}';

      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak dapat membuka Google Maps"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lokasiController = Provider.of<LokasiController>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const AppbarWidget(
        title: "Lokasi",
        hideLeading: true,
      ),
      body: Stack(
        children: [
          // Google Map
          _currentPosition == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: GreenPointColor.secondary,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  markers: _markers,
                ),
          // Floating Card
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
            child: lokasiController.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: GreenPointColor.secondary,
                    ),
                  )
                : SingleChildScrollView(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lokasi bank sampah terdekat.',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: GreenPointColor.secondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...lokasiController.lokasiList.map((lokasi) {
                              return ListTile(
                                title: Text(
                                  lokasi.namaLokasi,
                                  style:  TextStyle(color: GreenPointColor.secondary),
                                ),
                                subtitle: Text(
                                  lokasi.alamat ?? '',
                                  style:  TextStyle(color: GreenPointColor.secondary),
                                ),
                                trailing: IconButton(
                                  icon:  Icon(Icons.directions),
                                  color: GreenPointColor.secondary,
                                  onPressed: () => _launchRoute(lokasi),
                                ),
                              );
                            }).toList(),
                          ],
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
