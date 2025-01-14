import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ApiRepository {
  final String baseUrl = 'http://192.168.1.16:8080';

  Future<List<Review>> fetchReviews(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/reviews?movieId=$movieId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      // final List<dynamic> jsonArray = jsonMap['data'];

      // Map the JSON array to Review objects
      return jsonArray.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createReview(Review review) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(review.toJson()),
      );
    } catch (e) {
      throw Exception('Failed to create review');
    }
  }
}
