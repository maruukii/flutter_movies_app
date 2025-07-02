import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewRepository {
  final String baseUrl = 'http://${dotenv.env['BACKEND_URL']}:8080';

  Future<List<Review>> fetchReviews(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/reviews?movieId=$movieId'));
    print(movieId);
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
      await http.post(
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
