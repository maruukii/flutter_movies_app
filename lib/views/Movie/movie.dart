import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/all_review.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/models/review.dart';
import '../../repositories/review_repository.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';

class MoviePage extends StatefulWidget {
  final String movie;
  final int movieId;
  final String poster;
  final String description;
  final double rating;
  final int vote_count;
  final String release_date;
  const MoviePage(
      {Key? key,
      required this.movieId,
      required this.movie,
      required this.poster,
      required this.description,
      required this.rating,
      required this.vote_count,
      required this.release_date})
      : super(key: key);
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final ApiRepository _apiRepository = ApiRepository();
  final _auth = FirebaseAuth.instance;
  late Future<List<Review>> _data;

  @override
  void initState() {
    super.initState();
    _data = _apiRepository.fetchReviews(widget.movieId);
  }

  void _showReviewModal(String? username) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final _reviewController = TextEditingController();
        final _ratingController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _reviewController,
                    maxLength: 150,
                    decoration: InputDecoration(
                      labelText: 'Review Content',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _ratingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Rating (0.00 - 10.00)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final reviewContent = _reviewController.text;
                      final rating =
                          double.tryParse(_ratingController.text) ?? 0.0;
                      if (reviewContent.isNotEmpty &&
                          rating >= 0.0 &&
                          rating <= 10.0 &&
                          username != null) {
                        final review = new Review(
                            movieId: widget.movieId,
                            userId: _auth.currentUser!.uid,
                            username: username,
                            content: reviewContent,
                            date: DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(DateTime.now()),
                            rating: rating);
                        await _apiRepository.createReview(review);
                        setState(() {
                          _data = _apiRepository.fetchReviews(widget.movieId);
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit Review'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final expandedHeight = screenHeight * 2 / 3;
    const posterUrl = "https://image.tmdb.org/t/p/w500";
    final authViewModel = Provider.of<Authviewmodel>(context);
    final username = authViewModel.username;

    return MaterialApp(
      title: "Movies",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: expandedHeight,
              pinned: true,
              floating: false,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.movie,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  children: [
                    Image.network(
                      posterUrl + widget.poster,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 50.0,
                      right: 16.0,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 25,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              "${widget.rating.toStringAsFixed(2)} (${widget.vote_count})",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Movie Description",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "${widget.description}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          "Release Date",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " : ${widget.release_date}",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ))),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Reviews",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder<List<Review>>(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else {
                  final data = snapshot.data!;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final review = data[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          elevation: 4.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'images/default_profile.jpg'), // Placeholder image URL
                            ),
                            title: Text(review.username,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.content),
                                SizedBox(height: 8.0),
                                Text(
                                  review.date,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    review.rating.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: data.length,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showReviewModal(username),
          child: Icon(Icons.rate_review),
        ),
      ),
    );
  }
}
