class Ticket {
  final int id;
  final int userId;
  final int movieId;
  final String? movieTitle; // 🟢 Tên phim
  final String? movieImage; // 🟢 Poster phim
  final int cinemaId;
  final int roomId;
  final List<String> seats;
  final String showTime;
  final double totalPrice;
  final List<String>? foods; // 🟢 Danh sách bắp nước

  Ticket({
    required this.id,
    required this.userId,
    required this.movieId,
    this.movieTitle,
    this.movieImage,
    required this.cinemaId,
    required this.roomId,
    required this.seats,
    required this.showTime,
    required this.totalPrice,
    this.foods,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['userId'],
      movieId: json['movieId'],
      movieTitle: json['movieTitle'],
      movieImage: json['movieImage'],
      cinemaId: json['cinemaId'],
      roomId: json['roomId'],
      seats: List<String>.from(json['seats']),
      showTime: json['showTime'],
      totalPrice: json['totalPrice'].toDouble(),
      foods: json['foods'] != null ? List<String>.from(json['foods']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'movieImage': movieImage,
      'cinemaId': cinemaId,
      'roomId': roomId,
      'seats': seats,
      'showTime': showTime,
      'totalPrice': totalPrice,
      'foods': foods,
    };
  }
}