import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../database/database_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final dbService = DatabaseService();
  await dbService.connect();

  try {
    final reviewsCollection = dbService.getCollection('reviews');

    if (context.request.method == HttpMethod.post) {
      final body = await context.request.json();
      if (body is Map<String, dynamic>) {
        await reviewsCollection.insert(body);
      } else {
        throw Exception('Invalid body format');
      }

      return Response.json(
        body: {
          'status': 'success',
          'message': 'Review added successfully',
        },
      );
    }
    if (context.request.method == HttpMethod.delete &&
        context.request.uri.path == '/reviews/delete/userId/movieId') {
      final movieId = context.request.uri.queryParameters['movieId'];
      final userId = context.request.uri.queryParameters['userId'];
      if (movieId != null && userId != null) {
        final result = await reviewsCollection
            .deleteOne({'movieId': movieId, 'userId': userId});

        if (result.isSuccess) {
          return Response.json(
            body: {
              'status': 'success',
              'message': 'Review deleted successfully',
            },
          );
        } else {
          throw Exception('Review not found');
        }
      } else {
        throw Exception('movieId/userId parameter is required');
      }
    }
    if (context.request.method == HttpMethod.put &&
        context.request.uri.path == '/reviews/userId/movieId') {
      final movieId = context.request.uri.queryParameters['movieId'];
      final userId = context.request.uri.queryParameters['userId'];
      final body = await context.request.json();

      if (movieId != null && body is Map<String, dynamic> && userId != null) {
        final result = await reviewsCollection.update(
          {'movieId': movieId},
          {'\$set': body},
        );

        if (result.isNotEmpty) {
          return Response.json(
            body: {
              'status': 'success',
              'message': 'Review updated successfully',
            },
          );
        } else {
          throw Exception('Review not found');
        }
      } else {
        throw Exception('Invalid body format or missing movieId/userId');
      }
    }
    if (context.request.method == HttpMethod.get &&
        context.request.uri.path == '/reviews/movieId') {
      final movieId = context.request.uri.queryParameters['movieId'];

      if (movieId != null) {
        final review = await reviewsCollection.find({'movieId': movieId});

        return Response.json(
          body: review,
        );
      } else {
        throw Exception('movieId parameter is required');
      }
    }
    if (context.request.method == HttpMethod.get &&
        context.request.uri.path == '/reviews') {
      final reviews = await reviewsCollection.find().toList();

      return Response.json(
        body: {
          'status': 'success',
          'data': reviews,
        },
      );
    }
    return Response.json(
      statusCode: 404,
      body: {
        'status': 'error',
        'message': 'Route not found',
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {
        'status': 'error',
        'message': e.toString(),
      },
    );
  } finally {
    await dbService.close();
  }
}
