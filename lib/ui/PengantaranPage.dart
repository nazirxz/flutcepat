import 'package:flutter/material.dart';
import '../model/Pengantaran.dart';
import '../shared/theme.dart';
import 'RouteCard.dart';
import '../model/DetailPengantaran.dart';
import 'dart:math' show sqrt, pow, sin, cos, atan2;
import 'package:location/location.dart';

class PengantaranPage extends StatefulWidget {
  final List<Pengantaran> pengantaran;
  final String status;
  final String kurirId;
  final Future<void> Function()? onRefreshData;

  PengantaranPage({
    required this.pengantaran,
    required this.status,
    required this.kurirId,
    this.onRefreshData,
  });

  @override
  _PengantaranPageState createState() => _PengantaranPageState();
}

class _PengantaranPageState extends State<PengantaranPage> {
  LocationData? _currentPosition;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final LocationData position = await _location.getLocation();

    setState(() {
      _currentPosition = position;
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * atan2(sqrt(a), sqrt(1 - a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (widget.onRefreshData != null) {
          await widget.onRefreshData!();
        }
      },
      child: _buildRutePengantaranContent(context, widget.pengantaran),
    );
  }

  Widget _buildRutePengantaranContent(BuildContext context, List<Pengantaran> pengantaran) {
    List<DetailPengantaran> filteredDetails = pengantaran
        .expand((pengantaran) => pengantaran.detailPengantaran)
        .where((detail) => detail.status == widget.status)
        .toList();

    if (filteredDetails.isEmpty) {
      return Center(
        child: Text(
          widget.status == 'pending'
              ? 'Tidak ada pengantaran yang pending.'
              : 'Tidak ada pengantaran yang sudah dikirim.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Sort filteredDetails based on calculated distance
    double userLat = _currentPosition!.latitude!;
    double userLon = _currentPosition!.longitude!;

    filteredDetails.sort((a, b) {
      double distanceA = calculateDistance(userLat, userLon, a.latitude, a.longitude);
      double distanceB = calculateDistance(userLat, userLon, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB);
    });

    return ListView.builder(
      itemCount: filteredDetails.length,
      itemBuilder: (context, index) {
        final detail = filteredDetails[index];
        int ruteNumber = index + 1;
        double distance = calculateDistance(userLat, userLon, detail.latitude, detail.longitude);
        return RouteCard(
          routeName: "Rute $ruteNumber",
          noResi: detail.noResi,
          name: detail.namaPenerima,
          phone: detail.nohp,
          address: detail.alamatPenerima,
          latitude: detail.latitude,
          longitude: detail.longitude,
          kurirId: widget.kurirId,
          bgColor: widget.status == 'pending' ? Colors.yellow[100] : Colors.green[100],
          detailPengantaran: detail,
          distance: distance, // Add this parameter to RouteCard if you want to display the distance
          showRouteButton: widget.status == 'pending', // Only show button if status is pending
        );
      },
    );
  }
}
