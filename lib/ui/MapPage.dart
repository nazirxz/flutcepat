import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:sicepat/service/ApiService.dart';
import 'package:sicepat/model/DetailPengantaran.dart';

import 'BuktiPengantaranPage.dart';

class MapPage extends StatefulWidget {
  final String routeName;
  final double latitude;
  final double longitude;
  final String kurirId;
  final DetailPengantaran detailPengantaran;

  MapPage({
    required this.routeName,
    required this.latitude,
    required this.longitude,
    required this.kurirId,
    required this.detailPengantaran,
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
        _addMarkers();
      });
    } catch (e) {
      print('Error getting current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan lokasi saat ini')),
      );
    }
  }

  void _addMarkers() {
    setState(() {
      _markers.clear();
      if (_currentLocation != null) {
        _markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ));
      }
      _markers.add(Marker(
        markerId: MarkerId('destination'),
        position: LatLng(widget.latitude, widget.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
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
        _polylines.clear(); // Clear existing polylines
        _polylines.add(Polyline(
          polylineId: PolylineId('optimumRoute'),
          points: routePoints,
          color: Colors.blue,
          width: 5,
        ));

        _markers.clear();
        // Add marker for current location
        _markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ));

        // Add marker for the start of the route
        if (routePoints.isNotEmpty) {
          _markers.add(Marker(
            markerId: MarkerId('start'),
            position: routePoints.first,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ));

          // Add marker for the end of the route
          _markers.add(Marker(
            markerId: MarkerId('end'),
            position: routePoints.last,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));
        }
      });

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

  void _navigateToBukti() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BuktiPengantaranPage(
          detailPengantaran: widget.detailPengantaran,
        ),
      ),
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
            bottom: 70,
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
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _navigateToBukti,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Kirim Bukti Pengantaran',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
