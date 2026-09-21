import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../model/movie.dart';

class MovieProvider extends ChangeNotifier {
  final List<Movie> _movies = movieList;
  Movie? _selectedMovie;

  List<Movie> get movies => _movies;
  Movie? get selectedMovie => _selectedMovie;

  // Chọn phim
  void selectMovie(Movie movie) {
    _selectedMovie = movie;
    notifyListeners();
  }

  // Bỏ chọn phim
  void clearSelectedMovie() {
    _selectedMovie = null;
    notifyListeners();
  }

  // Thêm phim mới
  void addMovie(Movie newMovie) {
    _movies.add(newMovie);
    notifyListeners(); // Thông báo cập nhật sang trang đặt vé ngay lập tức
  }

  // Xóa phim theo ID và đồng bộ toàn app
  void deleteMovie(int id) {
    _movies.removeWhere((movie) => movie.id == id);
    if (_selectedMovie?.id == id) {
      _selectedMovie = null;
    }
    notifyListeners(); // 🔴 Xóa bên Admin -> Màn hình đặt vé tự động biến mất phim
  }

  // Cập nhật (Sửa) thông tin phim
  void updateMovie(Movie updatedMovie) {
    final index = _movies.indexWhere((m) => m.id == updatedMovie.id);
    if (index != -1) {
      _movies[index] = updatedMovie;
      notifyListeners(); // Thông báo cập nhật thông tin mới
    }
  }

  // Phê duyệt hoặc từ chối phim
  Future<bool> approveMovie(dynamic movieId, bool isApprove) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final int parsedId = movieId is int ? movieId : int.tryParse(movieId.toString()) ?? -1;

    final index = _movies.indexWhere((m) => m.id == parsedId);
    if (index != -1) {
      _movies[index].status = isApprove ? 'APPROVED' : 'REJECTED';
      notifyListeners();
      return true;
    }
    return false;
  }

  // Tìm kiếm phim
  List<Movie> searchMovie(String keyword) {
    return _movies.where((movie) {
      return movie.title.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }
}