// services/odoo_api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'odoo_auth_service.dart';

class OdooApiService {
  static Future<List<dynamic>> getCustomers(String url) async {
    final baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;

    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/web/dataset/call_kw/res.partner/search_read"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              if (OdooAuthService.sessionCookie != null)
                "Cookie": OdooAuthService.sessionCookie!,
            },
            body: jsonEncode({
              "jsonrpc": "2.0",
              "method": "call",
              "params": {
                "model": "res.partner",
                "method": "search_read",
                "args": [
                  [
                    ["customer_rank", ">", 0],
                  ],
                ],
                "kwargs": {
                  "fields": ["name", "email", "phone"],
                  "limit": 100,
                  "order": "name asc",
                },
              },
              "id": 1,
            }),
          )
          .timeout(const Duration(seconds: 20));

      debugPrint("Customers status: ${response.statusCode}");
      debugPrint("Customers body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      if (data["error"] != null) {
        final msg =
            data["error"]["data"]?["message"] ??
            data["error"]["message"] ??
            "Unknown Odoo error";
        throw Exception(msg);
      }

      final result = data["result"];
      if (result is List) return List<dynamic>.from(result);

      throw Exception("Unexpected response format");
    } catch (e) {
      debugPrint("getCustomers error: $e");
      rethrow;
    }
  }
}
