import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  final String routeName;
  final double latitude;
  final double longitude;

  MapPage({
    required this.routeName,
    required this.latitude,
    required this.longitude,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('destination'),
      position: LatLng(widget.latitude, widget.longitude),
      icon: BitmapDescriptor.defaultMarker,
    ));
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle case when permission is denied
      print('Permission denied');
    }
  }

  void _getCurrentLocation() async {
    try {
      var currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ));
      });
    } catch (e) {
      print('Error getting current location: $e');
      // Handle error here
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peta Rute: ${widget.routeName}'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 15.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                // Replace with your upload logic
                print('Upload Bukti');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Upload Bukti',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
