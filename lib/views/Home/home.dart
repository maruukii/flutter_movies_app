import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Movie/movie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final authViewModel = Provider.of<Authviewmodel>(context, listen: false);
    await authViewModel.getUserData(context);
    setState(() {
      isLoading = false;
    });
  }

  void _showSignOutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final authViewModel =
                    Provider.of<Authviewmodel>(context, listen: false);
                authViewModel.logout(context);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Sign Out"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context);
    final username = authViewModel.username;
    if (username != null) {
      setState(() {
        isLoading = false;
      });
    }
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("MoviesDB"),
              Row(
                children: [
                  Text(
                    "$username",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      onPressed: _showSignOutConfirmationDialog,
                      icon: Icon(Icons.logout))
                ],
              )
            ],
          )),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Expanded(child: TopRatedMoviesCarousel()),
          ],
        ),
      ),
    );
  }
}

class TopRatedMoviesCarousel extends StatefulWidget {
  const TopRatedMoviesCarousel({super.key});

  @override
  _TopRatedMoviesCarouselState createState() => _TopRatedMoviesCarouselState();
}

class _TopRatedMoviesCarouselState extends State<TopRatedMoviesCarousel> {
  List<dynamic> topRatedMovies = [];
  bool isLoading = true;
  String errorMessage = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
  }

  Future<void> fetchTopRatedMovies() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=${dotenv.env['movies_db_key']}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          topRatedMovies = json
              .decode(response.body)['results']
              .take(5)
              .toList(); // Show only the first 5 movies
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const posterUrl = "https://image.tmdb.org/t/p/w185";
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        const Text(
          "Top Rated Movies",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10), // Reduced spacing
        CarouselSlider.builder(
          itemCount: topRatedMovies.length.clamp(0, 5), // Limit to 5 movies
          itemBuilder: (context, index, realIndex) {
            final movie = topRatedMovies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviePage(
                      movieId: movie["id"],
                      movie: movie["original_title"],
                      poster: movie["poster_path"],
                      description: movie["overview"],
                      rating: movie["vote_average"].toDouble(),
                      vote_count: movie["vote_count"].toInt(),
                      release_date: movie["release_date"],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      posterUrl + movie['poster_path'],
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced spacing
                  Text(
                    movie['original_title'],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    overflow:
                        TextOverflow.ellipsis, // Use ellipsis for long titles
                    maxLines: 1, // Limit to 1 line
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 22,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "${(movie["vote_average"] as num).toStringAsFixed(2)}",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 422,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8), // Reduced spacing
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Text(
              topRatedMovies[_currentIndex]['overview'],
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
