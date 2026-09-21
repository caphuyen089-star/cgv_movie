import 'package:flutter/material.dart';
import '../model/showtime.dart';

class ShowtimeProvider extends ChangeNotifier {
  final List<Showtime> _showtimes = [
    Showtime(
      id: 1,
      movieId: '1',
      movieTitle: 'Mai',
      cinemaName: 'CGV Vincom Center', // 🟢 Thêm giá trị mẫu
      roomName: 'Phòng 01',
      date: '2026-04-01',
      time: '19:00',
    ),
  ];

  List<Showtime> get showtimes => _showtimes;

  // Kiểm tra trùng lịch dựa trên Rạp, Phòng, Ngày và Giờ
  bool isDuplicate(String cinemaName, String roomName, String date, String time, {int? excludeId}) {
    return _showtimes.any((st) =>
        st.cinemaName == cinemaName &&
        st.roomName == roomName &&
        st.date == date &&
        st.time == time &&
        st.id != excludeId);
  }

  bool addShowtime(Showtime newShowtime) {
    if (isDuplicate(newShowtime.cinemaName, newShowtime.roomName, newShowtime.date, newShowtime.time)) {
      return false;
    }
    _showtimes.add(newShowtime);
    notifyListeners();
    return true;
  }

  bool updateShowtime(Showtime updatedShowtime) {
    if (isDuplicate(
      updatedShowtime.cinemaName,
      updatedShowtime.roomName,
      updatedShowtime.date,
      updatedShowtime.time,
      excludeId: updatedShowtime.id,
    )) {
      return false;
    }

    final index = _showtimes.indexWhere((st) => st.id == updatedShowtime.id);
    if (index != -1) {
      _showtimes[index] = updatedShowtime;
      notifyListeners();
      return true;
    }
    return false;
  }

  void deleteShowtime(int id) {
    _showtimes.removeWhere((st) => st.id == id);
    notifyListeners();
  }
}