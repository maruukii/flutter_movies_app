import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';

class Movie extends StatelessWidget {
  final String movie;
  final String poster;
  const Movie({super.key, required this.movie, required this.poster});

  @override
  Widget build(BuildContext context) {
    const posterUrl = "https://image.tmdb.org/t/p/w500";
    final authViewModel = Provider.of<Authviewmodel>(context);
    final username = authViewModel.username;
    return MaterialApp(
        title: "Movies",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true),
        home: Scaffold(
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
                      Icon(Icons.person)
                    ],
                  )
                ],
              )),
          body: Container(child: Image.network(posterUrl + poster)),
        ));
  }
}
