// services/odoo_api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OdooApiService {
  static Future<List<dynamic>> getCustomers(String url) async {
    try {
      final response = await http
          .post(
            Uri.parse("$url/web/dataset/search_read"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({
              "jsonrpc": "2.0",
              "method": "call",
              "params": {
                "model": "res.partner",
                "domain": [],
                "fields": ["name", "email", "phone"],
                "limit": 50,
              },
              "id": 1,
            }),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint("Customers response: ${response.statusCode}");
      debugPrint("Customers body: ${response.body}");

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(response.body);

      if (data is Map && data["error"] != null) {
        return [];
      }

      final result = data is Map ? data["result"] : null;

      if (result is Map && result["records"] is List) {
        return List<dynamic>.from(result["records"]);
      }

      if (result is List) {
        return List<dynamic>.from(result);
      }

      return [];
    } catch (e) {
      debugPrint("getCustomers error: $e");
      return [];
    }
  }
}
