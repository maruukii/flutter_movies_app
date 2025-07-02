import 'package:dart_frog/dart_frog.dart';
import '../database/database_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final dbService = DatabaseService();
  await dbService.connect();

  try {
    final favoritesCollection = dbService.getCollection('favorites');

    final userId = context.request.uri.queryParameters['userId'];
    if (context.request.method == HttpMethod.put) {
      final movieId = context.request.uri.queryParameters['movieId'];
      if (movieId != null && userId != null) {
        final existingFavorite = await favoritesCollection.findOne({
          'userId': userId,
        });

        if (existingFavorite != null) {
          // Update existing favorite
          final movieIds = List<String>.from(
              (existingFavorite['movieIds'] as List<dynamic>)
                  .map((e) => e.toString()));
          if (movieIds.contains(movieId)) {
            movieIds.remove(movieId);
          } else {
            movieIds.add(movieId);
          }

          final result = await favoritesCollection.update(
            {'userId': userId},
            {
              '\$set': {'movieIds': movieIds}
            },
          );

          if (result.isNotEmpty) {
            return Response.json(
              body: {
                'status': 'success',
                'message': 'Favorite updated successfully',
              },
            );
          } else {
            throw Exception('Failed to update favorite');
          }
        } else {
          // Insert new favorite
          await favoritesCollection.insert({
            'userId': userId,
            'movieIds': [movieId],
          });

          return Response.json(
            body: {
              'status': 'success',
              'message': 'Favorite added successfully',
            },
          );
        }
      } else {
        throw Exception('Invalid body format or missing movieId/userId');
      }
    }

    if (context.request.method == HttpMethod.get) {
      if (userId != null) {
        final userFavorites = await favoritesCollection.findOne({
          'userId': userId,
        });

        if (userFavorites != null) {
          return Response.json(
            body: {
              'status': 'success',
              'data': userFavorites['movieIds'],
            },
          );
        } else {
          return Response.json(
            statusCode: 404,
            body: {
              'status': 'error',
              'message': 'User not found',
            },
          );
        }
      } else {
        throw Exception('Missing userId');
      }
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
