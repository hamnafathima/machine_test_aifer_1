import 'dart:convert';
import 'package:http/http.dart' as http;

class PexelsService {
  static const String _baseUrl = '';
  static const String _apiKey = '<API_KEY>';

  Future<List<dynamic>> fetchPhotos(int page, int perPage) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/curated?page=$page&per_page=$perPage'),
      headers: {'Authorization': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['photos'];
    } else {
      throw Exception('Failed to load photos');
    }
  }
}