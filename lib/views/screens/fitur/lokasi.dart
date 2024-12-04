import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/views/widget/appbar_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({Key? key}) : super(key: key);

  @override
  _LokasiPageState createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  late CameraPosition _initialCameraPosition;
  late Set<Marker> _markers;

  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

    // Get the current position of the user
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
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: 'Lokasi anda',
            snippet: 'lokasi anda saat ini!',
          ),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const AppbarWidget(
        title: "Lokasi",
        hideLeading: true,
      ),
      body: _currentPosition == null
          ? Center(
              child: CircularProgressIndicator(
              color: GreenPointColor.secondary,
            )) 
          : GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
              },
            ),
    );
  }
}
