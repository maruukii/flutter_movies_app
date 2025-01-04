import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For API calls
import 'package:provider/provider.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Profile/profile.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Movie/movie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context);
    final username = authViewModel.username;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Movies"),
              Row(
                children: [
                  Text(
                    "$username",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
                      icon: Icon(Icons.person))
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
            ElevatedButton(
                onPressed: () {
                  authViewModel.logout(context);
                },
                child: const Text('Sign Out'))
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=2c5bce24eb7693d0cee8afc86ec311d0');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body)['results'];
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
    const posterUrl = "https://image.tmdb.org/t/p/w500";
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

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final movie = data[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Movie(
                          movie: movie["original_title"],
                          poster: movie["poster_path"])));
            },
            leading: Image.network(posterUrl + movie['poster_path']),
            title: Text(
              movie['original_title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              movie['overview'],
              maxLines: 2, // Limit to 2 lines
              overflow:
                  TextOverflow.ellipsis, // Show ellipsis if text overflows
              style: TextStyle(fontSize: 14), // Adjust font size if needed
            ),
          ),
        );
      },
    );
  }
}
