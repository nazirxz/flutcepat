import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.100.76:9000/api/kurir';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/x-www-form-urlencoded', // Set for form data
  ));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
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
}
