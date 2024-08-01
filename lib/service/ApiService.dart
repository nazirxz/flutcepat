import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:io'; // For File
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:image/image.dart' as img;
import '../model/Pengantaran.dart';

class ApiService {
  static const String baseUrl = 'https://sicepat-pysk-c574a389fa73.herokuapp.com/';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'multipart/form-data',
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
    int lat = 0, lon = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLon = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lon += deltaLon;

      polyline.add(LatLng(lat / 1E5, lon / 1E5));
    }

    return polyline;
  }

  Future<void> uploadBuktiPengantaran({
    required String tanggalTerima,
    required String waktu,
    required String keterangan,
    required File gambar,
  }) async {
    final String url = '${baseUrl}api/bukti';

    try {
      final resizedImage = await _resizeImage(gambar);
      final formData = FormData.fromMap({
        'tanggal_terima': tanggalTerima,
        'waktu': waktu,
        'keterangan': keterangan,
        'gambar': await MultipartFile.fromFile(
          resizedImage.path,
          filename: resizedImage.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.post(url, data: formData);

      // Ubah kondisi ini untuk menerima status code 200 dan 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['status'] == 'success') {
          print('Bukti pengantaran berhasil dikirim');
          return;
        } else {
          final errorMessage = responseData['message'] ?? 'Unknown error';
          throw Exception('Failed to upload image: $errorMessage');
        }
      } else {
        throw Exception('Failed to upload bukti pengantaran, status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Error uploading bukti pengantaran: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response!.data}');
        print('Response headers: ${e.response!.headers}');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<bool> updateDetailPengantaranStatus(int id, String status) async {
    try {
      final response = await _dio.post(
        'api/pengantaran/update-status',
        data: FormData.fromMap({
          'id': id,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['message'] == 'Status updated successfully') {
          return true;
        } else {
          print('Server returned success status code but update failed: ${responseData['message']}');
          return false;
        }
      } else {
        print('Failed to update status. Status code: ${response.statusCode}');
        return false;
      }
    } on DioError catch (e) {
      print('Network error when updating status: ${e.message}');
      return false;
    }
  }

  Future<File> _resizeImage(File imageFile) async {
    final image = img.decodeImage(imageFile.readAsBytesSync())!;
    final resizedImage = img.copyResize(image, width: 800); // Adjust size as needed
    final resizedImageFile = File('${imageFile.path}_resized.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage));
    return resizedImageFile;
  }
}
