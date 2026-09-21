import 'package:flutter/material.dart';

class SeatProvider extends ChangeNotifier {
  final List<String> _selectedSeats = [];

  final List<String> _bookedSeats = [
    "A3",
    "A4",
    "B5",
    "C7",
  ];

  List<String> get selectedSeats => _selectedSeats;

  List<String> get bookedSeats => _bookedSeats;

  bool isBooked(String seat) {
    return _bookedSeats.contains(seat);
  }

  bool isSelected(String seat) {
    return _selectedSeats.contains(seat);
  }

  void toggleSeat(String seat) {
    if (isBooked(seat)) return;

    if (_selectedSeats.contains(seat)) {
      _selectedSeats.remove(seat);
    } else {
      _selectedSeats.add(seat);
    }

    notifyListeners();
  }

  void confirmBooking() {
    _bookedSeats.addAll(_selectedSeats);
    _selectedSeats.clear();
    notifyListeners();
  }

  void clearSelection() {
    _selectedSeats.clear();
    notifyListeners();
  }
}