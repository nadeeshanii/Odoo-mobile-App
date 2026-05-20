// services/odoo_auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OdooAuthService {

  static Future<List<String>> fetchDatabases(String url) async {
    final response = await http.post(
      Uri.parse("$url/web/database/list"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "call",
        "params": {}
      }),
    );

    final data = jsonDecode(response.body);
    return List<String>.from(data['result'] ?? []);
  }

  // ✅ FIXED LOGIN
  static Future<Map<String, dynamic>?> login(
    String url,
    String db,
    String login,
    String password,
  ) async {

    final response = await http.post(
      Uri.parse("$url/web/session/authenticate"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {
          "db": db,
          "login": login,
          "password": password,
        }
      }),
    );

    final data = jsonDecode(response.body);

    if (data['result'] != null && data['result']['uid'] != null) {
      return {
        "uid": data['result']['uid'],
        "name": data['result']['name'] ?? login,
        "session_id": response.headers['set-cookie'],
      };
    }

    return null;
  }
}