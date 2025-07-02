import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/models/favorite.dart';
import 'package:http/http.dart' as http;

class FavoriteRepository {
  final String baseUrl = 'http://${dotenv.env['BACKEND_URL']}:8080';

  Future<List<String>> fetchFavorites(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/favorites?userId=$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        final List<dynamic> jsonArray = jsonResponse['data'];
        return List<String>.from(jsonArray);
      } else {
        throw Exception('Failed to load data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addToFavorite(String userId, int movieId) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/favorites?userId=$userId&movieId=$movieId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      throw Exception('Failed to add movie to favorite');
    }
  }
}
