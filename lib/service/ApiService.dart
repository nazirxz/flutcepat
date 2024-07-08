import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sicepat/model/Kurir.dart';
import 'package:sicepat/model/Pengantaran.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/kurir'; // Update with correct base URL

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/json',
  ));

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.data}");
        return response.data;
      } else {
        print("Failed to login with status code: ${response.statusCode}");
        print("Response body: ${response.data}");
        throw Exception('Failed to login');
      }
    } catch (e) {
      print("An error occurred during login: $e");
      throw Exception('Failed to login');
    }
  }
}