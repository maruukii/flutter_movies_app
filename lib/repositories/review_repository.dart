import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ApiRepository {
  final String baseUrl = 'http://192.168.1.16:8080';

  Future<List<Review>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/reviews'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      final List<dynamic> jsonArray = jsonMap['data'];

      // Map the JSON array to Review objects
      return jsonArray.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
