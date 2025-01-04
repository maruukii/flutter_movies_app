import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For API calls
import 'package:provider/provider.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';

class HomePage extends StatelessWidget {
  final String? username;

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Welcome Back $username!!",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
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
        'https://my-json-server.typicode.com/horizon-code-academy/fake-movies-api/movies'); // API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body); // Parse JSON data
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
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                movie['RunTime'].toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              movie['Title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Year: ${movie['Year']}'),
          ),
        );
      },
    );
  }
}
