import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://opentdb.com';

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api_category.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categories = data['trivia_categories'];
      return categories.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
