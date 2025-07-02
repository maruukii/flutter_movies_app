class Favorite {
  final String userId;
  final List<String> movieId;

  Favorite({
    required this.movieId,
    required this.userId,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      movieId: List<String>.from(json['movieId']),
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'userId': userId,
    };
  }
}
