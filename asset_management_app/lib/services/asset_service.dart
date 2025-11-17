import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AssetService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<bool> addAsset({
    required String name,
    required String location,
    required String description,
    required int categoryId,
    required File imageFile,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/asset/add");

      var request = http.MultipartRequest("POST", uri);

      request.fields["name"] = name;
      request.fields["location"] = location;
      request.fields["description"] = description;
      request.fields["categoryId"] = categoryId.toString();

      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );

      final response = await request.send();

      print("Asset Upload → ${response.statusCode}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Upload Error: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAssets() async {
    try {
      final url = Uri.parse("$baseUrl/asset/");
      final response = await http.get(url);

      // print("Status Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Failed to fetch assets. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<bool> assetDeleteToggle({
    required int id,
    required bool isActive,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/asset/delete/$id');

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

  Future<bool> assetSaveToggle({required int id, required bool isSaved}) async {
    try {
      final url = Uri.parse('$baseUrl/asset/toggle/isSaved/$id');

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"isSaved": isSaved}),
      );
      print("Toggle Response: ${response.statusCode} → ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("save asset toggle error: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchSavedAssets() async {
    try {
      final url = Uri.parse("$baseUrl/asset/saved_assets");
      final response = await http.get(url);

      // print("Status Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Failed to fetch saved assets. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }
}
