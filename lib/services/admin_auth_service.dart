import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api.dart';

class AdminAuthService {
  /// 🔐 Admin Signup
  static Future<Map<String, dynamic>> signup(
      String email, String username, String password, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin_signup.php'),
        body: {
          'email': email,
          'username': username,
          'password': password,
          'phone': phone,
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  /// 🔓 Admin Login
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin_login.php'),
        body: {
          'username': username,
          'password': password,
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
  static Future<List<Map<String, dynamic>>> fetchAllStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_all_students.php'));
      final body = json.decode(response.body);

      if (body['success'] == true && body['data'] is List) {
        return List<Map<String, dynamic>>.from(body['data']);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }


  /// 🔁 Admin Forgot Password
  static Future<Map<String, dynamic>> resetPassword(
      String email, String username, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin_forgot_password.php'),
        body: {
          'email': email,
          'username': username,
          'new_password': newPassword,
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Exception: $e'};
    }
  }
}
