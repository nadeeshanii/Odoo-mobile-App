// services/odoo_auth_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OdooAuthService {
  static String? sessionCookie;

  static String _normalizeBaseUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Enter the Odoo server URL first.');
    }

    final withScheme =
        trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : 'http://$trimmed';

    final uri = Uri.tryParse(withScheme);
    if (uri == null || uri.host.isEmpty) {
      throw const FormatException(
        'Enter a valid server URL such as 192.168.1.10:8069.',
      );
    }

    return withScheme.endsWith('/')
        ? withScheme.substring(0, withScheme.length - 1)
        : withScheme;
  }

  static String _databaseErrorMessage(Object error) {
    final errorText = error.toString();

    if (errorText.contains('Enter the Odoo server URL first')) {
      return 'Enter the Odoo server URL before loading databases.';
    }

    if (errorText.contains('Enter a valid server URL')) {
      return 'Use a valid Odoo server address like 192.168.1.10:8069.';
    }

    if (kIsWeb) {
      if (errorText.contains('TimeoutException')) {
        return 'Chrome could not reach the Odoo server. Check the server URL, network, and CORS settings.';
      }

      return 'Chrome blocked the request or could not reach the Odoo server. Enable CORS on Odoo or use a reachable HTTPS/proxy endpoint.';
    }

    if (errorText.contains('TimeoutException')) {
      return 'Request timed out. Check the Odoo server URL and network connectivity.';
    }

    return errorText;
  }

  static Future<List<String>> fetchDatabases(String url) async {
    final baseUrl = _normalizeBaseUrl(url);

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/web/database/list'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'jsonrpc': '2.0',
              'method': 'call',
              'params': {},
            }),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('Database list status: ${response.statusCode}');
      debugPrint('Database list body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        if (data['error'] != null) {
          final message =
              data['error']['data']?['message'] ??
              data['error']['message'] ??
              'Unknown Odoo error';
          throw Exception(message);
        }

        final result = data['result'];
        if (result is List) {
          return List<String>.from(result);
        }
      }

      throw const FormatException(
        'Unexpected response from Odoo database list.',
      );
    } catch (e) {
      final message = _databaseErrorMessage(e);
      debugPrint('fetchDatabases error: $message');
      throw Exception(message);
    }
  }

  static Future<Map<String, dynamic>?> login(
    String url,
    String db,
    String login,
    String password,
  ) async {
    final baseUrl = _normalizeBaseUrl(url);

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/web/session/authenticate'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'jsonrpc': '2.0',
              'params': {'db': db, 'login': login, 'password': password},
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      sessionCookie = response.headers['set-cookie'];

      if (data['result'] != null && data['result']['uid'] != null) {
        return data['result'];
      }

      return null;
    } catch (e) {
      debugPrint('login error: $e');
      throw Exception(_databaseErrorMessage(e));
    }
  }
}
