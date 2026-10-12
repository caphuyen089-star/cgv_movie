import 'package:flutter/material.dart';
import '../data/movie_data.dart';
import '../model/movie.dart';

class MovieProvider extends ChangeNotifier {
  // Danh sách gốc chứa tất cả các phim
  final List<Movie> _allMovies = List.from(movieList);
  
  // Danh sách phim hiển thị trên giao diện (đã qua lọc)
  List<Movie> _filteredMovies = List.from(movieList);
  
  Movie? _selectedMovie;

  // Getter trả về danh sách phim đã lọc cho UI
  List<Movie> get movies => _filteredMovies;
  Movie? get selectedMovie => _selectedMovie;

  // 🟢 HÀM LỌC PHIM CỦA BẠN DÙNG TRONG ONTAP
  void filterMovies(String category) {
    _filteredMovies = _allMovies.where((movie) {
      return movie.category == category;
    }).toList();
    notifyListeners(); // Cập nhật lại giao diện ngay
  }

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
    _allMovies.add(newMovie);
    _filteredMovies.add(newMovie);
    notifyListeners();
  }

  // Xóa phim theo ID
  void deleteMovie(int id) {
    _allMovies.removeWhere((movie) => movie.id == id);
    _filteredMovies.removeWhere((movie) => movie.id == id);
    if (_selectedMovie?.id == id) {
      _selectedMovie = null;
    }
    notifyListeners();
  }

  // Cập nhật thông tin phim
  void updateMovie(Movie updatedMovie) {
    final indexAll = _allMovies.indexWhere((m) => m.id == updatedMovie.id);
    if (indexAll != -1) {
      _allMovies[indexAll] = updatedMovie;
    }

    final indexFilter = _filteredMovies.indexWhere((m) => m.id == updatedMovie.id);
    if (indexFilter != -1) {
      _filteredMovies[indexFilter] = updatedMovie;
    }

    notifyListeners();
  }

  // Phê duyệt hoặc từ chối phim
  Future<bool> approveMovie(dynamic movieId, bool isApprove) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final int parsedId = movieId is int ? movieId : int.tryParse(movieId.toString()) ?? -1;

    final index = _allMovies.indexWhere((m) => m.id == parsedId);
    if (index != -1) {
      _allMovies[index].status = isApprove ? 'APPROVED' : 'REJECTED';
      notifyListeners();
      return true;
    }
    return false;
  }

  // Tìm kiếm phim
  List<Movie> searchMovie(String keyword) {
    return _allMovies.where((movie) {
      return movie.title.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }
}