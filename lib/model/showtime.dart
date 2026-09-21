class Showtime {
  final int id;
  final String movieId;
  final String movieTitle;
  final String cinemaName; // 🟢 Thêm rạp phim
  final String roomName;
  final String date;
  final String time;

  Showtime({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaName,
    required this.roomName,
    required this.date,
    required this.time,
  });
}