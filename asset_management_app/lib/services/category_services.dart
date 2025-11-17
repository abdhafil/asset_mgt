import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker_platform_interface/src/types/picked_file/unsupported.dart';

class CategoryServices {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<bool> addCategory({required String name}) async {
    final url = Uri.parse('$baseUrl/category/add');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Map<String, dynamic>>> fetchAllCategory() async {
    try {
      final url = Uri.parse("$baseUrl/category/view/all");
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<Map<String, dynamic>> categories = jsonData
            .map((e) => e as Map<String, dynamic>)
            .toList();
        // print("Fetched categories: $categories");
        return categories;
      } else {
        print(" Failed to fetch categories. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchActiveCategory() async {
    try {
      final url = Uri.parse("$baseUrl/category/view_active");
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<Map<String, dynamic>> categories = jsonData
            .map((e) => e as Map<String, dynamic>)
            .toList();
        // print("Fetched categories: $categories");
        return categories;
      } else {
        print(" Failed to fetch categories. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<bool> categoryToggle({required int id, required bool isActive}) async {
    try {
      final url = Uri.parse('$baseUrl/category/toggle/isActive/$id');

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"isActive": isActive}),
      );

      print("Toggle Response: ${response.statusCode} → ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Toggle category error: $e");
      return false;
    }
  }

  Future<bool> categoryDelete({id}) async {
    try {
      final url = Uri.parse('$baseUrl/category/delete/$id');

      final response = await http.delete(url);

      print("Delete Response: ${response.statusCode} → ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Detele category error: $e");
      return false;
    }
  }
}
