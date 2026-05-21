// services/odoo_auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OdooAuthService {
  static String? sessionCookie;

  // =========================
  // FETCH DATABASES
  // =========================
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

  // =========================
  // LOGIN (SAVE SESSION)
  // =========================
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

    // 🔥 SAVE SESSION COOKIE (IMPORTANT FIX)
    sessionCookie = response.headers['set-cookie'];

    if (data['result'] != null && data['result']['uid'] != null) {
      return data['result'];
    }

    return null;
  }
}