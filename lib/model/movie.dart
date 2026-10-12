class Movie {
  final int id;
  final String title;
  final String image;
  final String banner;
  final String trailer;
  final String description;
  final String genre;
  final int duration;
  final double rating;
  final String releaseDate;
  String status; // 🟢 'PENDING', 'APPROVED', 'REJECTED'
  String? category;

  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.banner,
    required this.trailer,
    required this.description,
    required this.genre,
    required this.duration,
    required this.rating,
    required this.releaseDate,
    this.status = 'PENDING', // Mặc định là Chờ duyệt
    this.category,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      banner: json['banner'],
      trailer: json['trailer'],
      description: json['description'],
      genre: json['genre'],
      duration: json['duration'],
      rating: json['rating'].toDouble(),
      releaseDate: json['releaseDate'],
      status: json['status'] ?? 'PENDING',
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'banner': banner,
      'trailer': trailer,
      'description': description,
      'genre': genre,
      'duration': duration,
      'rating': rating,
      'releaseDate': releaseDate,
      'status': status,
      'category': category,
    };
  }
}