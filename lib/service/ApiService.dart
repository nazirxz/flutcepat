import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import '../model/Pengantaran.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.100.76:8080/';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/x-www-form-urlencoded',
  ));
  final String googleApiKey = 'AIzaSyC-S0PiFJUQ12lQUmPfg1QWPKzWwLg-JdU';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'api/kurir/login',
        data: FormData.fromMap({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to login with status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Pengantaran>> getPengantaranByKurir(String kurirId) async {
    try {
      final response = await _dio.get('api/pengantaran/kurir/$kurirId');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        return responseData.map((json) => Pengantaran.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch pengantaran data with status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<LatLng>> getOptimalRoute(int kurirId, double startLat, double startLon) async {
    try {
      final response = await _dio.get(
        'api/rute/optimize/$kurirId',
        queryParameters: {
          'start_lat': startLat,
          'start_lon': startLon,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> routePoints = data['optimal_route'];

        List<LatLng> waypoints = routePoints.map((point) => LatLng(
            double.parse(point['lat']),
            double.parse(point['lon'])
        )).toList();

        return await _getRouteFromGoogleDirectionsApi(waypoints);
      } else {
        throw Exception('Failed to fetch optimal route with status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<LatLng>> _getRouteFromGoogleDirectionsApi(List<LatLng> waypoints) async {
    if (waypoints.isEmpty) return [];

    String waypointsString = waypoints.skip(1).map((point) => '${point.latitude},${point.longitude}').join('|');

    String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${waypoints.first.latitude},${waypoints.first.longitude}'
        '&destination=${waypoints.last.latitude},${waypoints.last.longitude}'
        '&waypoints=$waypointsString'
        '&key=$googleApiKey';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'OK') {
          List<LatLng> routePoints = [];
          var steps = data['routes'][0]['legs'][0]['steps'];
          for (var step in steps) {
            var polylinePoints = decodePolyline(step['polyline']['points']);
            routePoints.addAll(polylinePoints);
          }
          return routePoints;
        } else {
          throw Exception('Directions API error: ${data['status']}');
        }
      } else {
        throw Exception('Failed to fetch directions with status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  Future<void> updateDetailPengantaranStatus(String detailPengantaranId, String status) async {
    try {
      final response = await _dio.post(
        'api/pengantaran/update-status',
        data: FormData.fromMap({
          'id': detailPengantaranId,
          'status': status,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update pengantaran status with status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}