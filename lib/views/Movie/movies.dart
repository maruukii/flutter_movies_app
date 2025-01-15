import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Movie/movie.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(child: FetchDataExample()),
          ],
        ),
      ),
    );
  }
}

class FetchDataExample extends StatefulWidget {
  const FetchDataExample({super.key});

  @override
  _FetchDataExampleState createState() => _FetchDataExampleState();
}

class _FetchDataExampleState extends State<FetchDataExample> {
  List<dynamic> data = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedCategory = 'upcoming';
  int _currentPage = 1;
  bool _showFavoriteOnly = false;
  List<int> FavoriteMovies = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$selectedCategory?api_key=${dotenv.env['movies_db_key']}&page=$_currentPage');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          data.addAll(json.decode(response.body)['results']);
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

  Future<void> _loadMoreData() async {
    setState(() {
      _currentPage++;
      isLoading = true;
    });
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    const posterUrl = "https://image.tmdb.org/t/p/w500";
    if (isLoading && _currentPage == 1) {
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

    List<dynamic> displayedData = _showFavoriteOnly
        ? data.where((movie) => FavoriteMovies.contains(movie['id'])).toList()
        : data;

    return Column(
      children: [
        DropdownButton<String>(
          value: selectedCategory,
          items:
              <String>['upcoming', 'popular', 'top_rated'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.replaceAll('_', ' ').toUpperCase()),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
              _currentPage = 1;
              data.clear();
              isLoading = true;
              fetchData();
            });
          },
        ),
        SwitchListTile(
          title: Text("Show Favorite Only"),
          value: _showFavoriteOnly,
          onChanged: (bool value) {
            setState(() {
              _showFavoriteOnly = value;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: displayedData.length + 1,
            itemBuilder: (context, index) {
              if (index == displayedData.length) {
                return isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SizedBox.shrink();
              }
              final movie = displayedData[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
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
                                )));
                  },
                  leading: Image.network(posterUrl + movie['poster_path']),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 22,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          "${(movie["vote_average"] as num).toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    movie['original_title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    movie['overview'],
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow
                        .ellipsis, // Show ellipsis if text overflows
                    style:
                        TextStyle(fontSize: 14), // Adjust font size if needed
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _currentPage > 1
                  ? () {
                      setState(() {
                        _currentPage--;
                        data.clear();
                        isLoading = true;
                        fetchData();
                      });
                    }
                  : null,
              child: Text("Previous"),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentPage++;
                  data.clear();
                  isLoading = true;
                  fetchData();
                });
              },
              child: Text("Next"),
            ),
          ],
        ),
      ],
    );
  }
}
