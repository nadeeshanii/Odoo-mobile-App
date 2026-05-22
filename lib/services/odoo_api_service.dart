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
                  "fields": [
                    "name",
                    "email",
                    "phone",
                    "mobile",
                    "street",
                    "city",
                    "company_type",
                  ],
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

  static Future<int> createCustomer(
    String url, {
    required String name,
    String email = '',
    String phone = '',
    String mobile = '',
    String street = '',
    String city = '',
    String companyType = 'person',
  }) async {
    final baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/web/dataset/call_kw/res.partner/create'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (OdooAuthService.sessionCookie != null)
                'Cookie': OdooAuthService.sessionCookie!,
            },
            body: jsonEncode({
              'jsonrpc': '2.0',
              'method': 'call',
              'params': {
                'model': 'res.partner',
                'method': 'create',
                'args': [
                  {
                    'name': name,
                    'email': email,
                    'phone': phone,
                    'mobile': mobile,
                    'street': street,
                    'city': city,
                    'company_type': companyType,
                  },
                ],
                'kwargs': {},
              },
              'id': 3,
            }),
          )
          .timeout(const Duration(seconds: 20));

      debugPrint('Create customer status: ${response.statusCode}');
      debugPrint('Create customer body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['error'] != null) {
        final msg =
            data['error']['data']?['message'] ??
            data['error']['message'] ??
            'Unknown Odoo error';
        throw Exception(msg);
      }

      final result = data['result'];
      if (result is int) return result;

      throw Exception('Unexpected response format');
    } catch (e) {
      debugPrint('createCustomer error: $e');
      rethrow;
    }
  }

  // GET SALES ORDERS

  static Future<List<dynamic>> getSalesOrders(String url) async {
    final baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;

    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/web/dataset/call_kw/sale.order/search_read"),
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
                "model": "sale.order",
                "method": "search_read",
                "args": [[]],
                "kwargs": {
                  "fields": ["name", "amount_total", "state", "partner_id"],
                  "limit": 100,
                  "order": "name desc",
                },
              },
              "id": 2,
            }),
          )
          .timeout(const Duration(seconds: 20));

      debugPrint("Sales Orders status: ${response.statusCode}");
      debugPrint("Sales Orders body: ${response.body}");

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
      debugPrint("getSalesOrders error: $e");
      rethrow;
    }
  }
}
