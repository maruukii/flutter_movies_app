class Review {
  final String movieId;
  final String userId;
  final String content;
  final String date;
  final double rating;

  Review(
      {required this.movieId,
      required this.userId,
      required this.content,
      required this.date,
      required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      movieId: json['movieId'],
      userId: json['userId'],
      content: json['content'],
      date: json['date'],
      rating: json['rating'],
    );
  }
}
