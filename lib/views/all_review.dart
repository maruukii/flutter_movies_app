import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/models/review.dart';
import '../repositories/review_repository.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final ApiRepository _apiRepository = ApiRepository();
  late Future<List<Review>> _data;

  @override
  void initState() {
    super.initState();
    _data = _apiRepository.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Full-Stack')),
      body: FutureBuilder<List<Review>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final review = data[index];
                return ListTile(
                  title: Text(review.userId, style: TextStyle(fontSize: 20)),
                  subtitle: Text(review.content),
                );
              },
            );
          }
        },
      ),
    );
  }
}
