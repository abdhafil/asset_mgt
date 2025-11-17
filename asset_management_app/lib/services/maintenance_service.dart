import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MaintenanceService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<List<Map<String, dynamic>>> fetchMaintenance({
    required int assetId,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/maintenance/view/$assetId");
      final response = await http.get(url);

      // print("Status Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Failed to fetch Maintenance. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<bool> addMaintenance({
    required String maintenance_type,
    required DateTime date,
    required String performed_by,
    required String notes,
    required int assetId,
  }) async {
    final url = Uri.parse("$baseUrl/maintenance/add/$assetId");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'maintenance_type': maintenance_type,
        "date": date.toUtc().toIso8601String(),
        'performed_by': performed_by,
        'notes': notes,
        'assetId': assetId,
      }),
    );

    // print("Status: ${response.statusCode}");
    // print("Body: ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> maintenanceDeleteToggle({
    required int id,
    required bool isActive,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/maintenance/delete/$id');

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"isActive": isActive}),
      );
      print("Toggle Response: ${response.statusCode} → ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("delete asset toggle error: $e");
      return false;
    }
  }
}
