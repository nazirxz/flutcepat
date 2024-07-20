import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:sicepat/service/ApiService.dart'; // Sesuaikan dengan path yang benar

class MapPage extends StatefulWidget {
  final String routeName;
  final double latitude;
  final double longitude;
  final String kurirId;

  MapPage({
    required this.routeName,
    required this.latitude,
    required this.longitude,
    required this.kurirId,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

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
      print('Permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Izin lokasi diperlukan untuk fitur ini')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi saat ini')),
      );
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

  void _determineRoute() async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lokasi saat ini tidak tersedia')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<LatLng> routePoints = await _apiService.getOptimalRoute(
          int.parse(widget.kurirId),
          _currentLocation!.latitude,
          _currentLocation!.longitude
      );

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('optimumRoute'),
          points: routePoints,
          color: Colors.blue,
          width: 5,
        ));

        // Tambahkan marker untuk setiap titik pengantaran
        for (int i = 1; i < routePoints.length; i++) {
          _markers.add(Marker(
            markerId: MarkerId('point_$i'),
            position: routePoints[i],
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));
        }
      });

      // Sesuaikan kamera untuk menampilkan seluruh rute
      LatLngBounds bounds = _getBounds(routePoints);
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } catch (e) {
      print('Error getting optimal route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan rute optimal')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;
    for (LatLng point in points) {
      minLat = minLat == null ? point.latitude : min(minLat, point.latitude);
      maxLat = maxLat == null ? point.latitude : max(maxLat, point.latitude);
      minLng = minLng == null ? point.longitude : min(minLng, point.longitude);
      maxLng = maxLng == null ? point.longitude : max(maxLng, point.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
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
            polylines: _polylines,
            myLocationEnabled: true,
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _determineRoute,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Tentukan Jarak Rute',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
