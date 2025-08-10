import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/api.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {'username': username, 'password': password},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> signup(String studentId, String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup.php'),
      body: {
        'student_id': studentId,
        'username': username,
        'email': email,
        'password': password,
      },
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> forgotPassword(String studentId, String username, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot_password.php'),
      body: {
        'student_id': studentId,
        'username': username,
        'new_password': newPassword,
      },
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getUserData(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_user_data.php?username=$username'),
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> updateComment(String username, String comment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comment_submit.php'),
      body: {
        'username': username,
        'comment': comment,
      },
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getUserDetails(String username) async {
    final url = Uri.parse('$baseUrl/get_user_info.php');
    try {
      final response = await http.post(url, body: {'username': username});
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Exception occurred: $e'};
    }
  }
}
