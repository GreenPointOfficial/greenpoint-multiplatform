import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/controllers/lokasi_controller.dart';
import 'package:greenpoint/models/lokasi_model.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart'; // Tambahkan import untuk url_launcher

class LokasiPage extends StatefulWidget {
  const LokasiPage({Key? key}) : super(key: key);

  @override
  _LokasiPageState createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  final PageController _pageController = PageController();

  late CameraPosition _initialCameraPosition;
  late Set<Marker> _markers;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
      _fetchLokasiData();
    });
  }

  Future<void> _fetchLokasiData() async {
    final lokasiController =
        Provider.of<LokasiController>(context, listen: false);
    await lokasiController.fetchLokasi(); // Fetch lokasi data
    if (_currentPosition != null) {
      _updateMarkers(lokasiController
          .lokasiList); // Update markers after fetching lokasi data
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

      _markers = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(
            title: 'Lokasi anda',
            snippet: 'Lokasi anda saat ini!',
          ),
        ),
      };
    });
  }

  void _updateMarkers(List<LokasiModel> lokasiList) {
    setState(() {
      _markers.addAll(
        lokasiList.map((lokasi) {
          return Marker(
            markerId: MarkerId(lokasi.id.toString()),
            position: LatLng(
              lokasi.latitude, // Convert from string to double
              lokasi.longitude, // Convert from string to double
            ),
            infoWindow: InfoWindow(
              title: lokasi.namaLokasi,
              snippet: lokasi.keterangan ?? '',
            ),
          );
        }),
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
        throw 'Could not open the maps.';
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
                ))
              : GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {},
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
                : lokasiController.errorMessage != null
                    ? Center(child: Text(lokasiController.errorMessage!))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: lokasiController.lokasiList.length,
                        itemBuilder: (context, index) {
                          final lokasi = lokasiController.lokasiList[index];
                          return _buildCardLokasi(context, lokasi);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardLokasi(BuildContext context, LokasiModel lokasi) {
    return GestureDetector(
      onTap: () {
        _launchRoute(lokasi); // Panggil fungsi untuk membuka rute
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Image.asset(
                'lib/assets/imgs/logo_edukasi1.png',
                width: ScreenUtils.screenWidth(context) * 0.3,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lokasi.namaLokasi,
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        lokasi.alamat,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lokasi.keterangan ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SmoothPageIndicator(
                count: 2,
                controller: _pageController,
                effect: ExpandingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: GreenPointColor.secondary,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
