import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String routeName;

  MapPage({required this.routeName});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  // Sample coordinates for demonstration
  final LatLng _startLocation = const LatLng(-6.2088, 106.8456);
  final LatLng _destinationLocation = const LatLng(-6.2122, 106.8469);

  // Markers for start and end
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('start'),
      position: _startLocation,
      icon: BitmapDescriptor.defaultMarker,
    ));
    _markers.add(Marker(
      markerId: MarkerId('destination'),
      position: _destinationLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
              target: _startLocation,
              zoom: 15.0,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 16, // Adjust positioning as needed
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {}, // Replace with your upload logic
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
