import 'package:dio/dio.dart';

import '../model/Pengantaran.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.43.137:8081/';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/x-www-form-urlencoded', // Set for form data
  ));

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
        return response.data; // Return response data if successful
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
}
