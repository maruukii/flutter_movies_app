class Review {
  final int movieId;
  final String userId;
  final String username;
  final String content;
  final String date;
  final double rating;

  Review(
      {required this.movieId,
      required this.userId,
      required this.content,
      required this.date,
      required this.rating,
      required this.username});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      movieId: json['movieId'],
      userId: json['userId'],
      username: json['username'],
      content: json['content'],
      date: json['date'],
      rating: json['rating'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'userId': userId,
      'username': username,
      'content': content,
      'date': date,
      'rating': rating,
    };
  }
}
