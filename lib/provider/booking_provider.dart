import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện định dạng ngày tháng/tiền tệ nếu cần
import 'dart:async';
import '../model/movie.dart';
import '../model/food.dart';
import '../data/food_data.dart'; 

class BookingProvider with ChangeNotifier {
  Movie? _selectedMovie;
  List<String> _selectedSeats = [];
  
  final Map<int, int> _foodQuantities = {};
  final int _ticketPrice = 120000; // Giá vé 120k/ghế

  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isTimeout = false;

  // 🎟️ THÊM: Biến quản lý Voucher
  String? _appliedVoucherCode;
  double _discountAmount = 0;

  // 🛠️ Danh sách lưu trữ vé đã đặt động
  final List<Map<String, String>> _bookedTickets = [
    {
      "movie": "Avengers: Endgame",
      "cinema": "CGV Vincom",
      "date": "15/07/2026",
      "time": "19:30",
      "seat": "A5",
      "price": "120.000đ",
    },
    {
      "movie": "Spider-Man",
      "cinema": "CGV Aeon",
      "date": "20/07/2026",
      "time": "20:00",
      "seat": "B8",
      "price": "150.000đ",
    },
  ];

  Movie? get selectedMovie => _selectedMovie;
  List<String> get selectedSeats => _selectedSeats;
  Map<int, int> get foodQuantities => _foodQuantities;

  int get remainingSeconds => _remainingSeconds;
  bool get isTimeout => _isTimeout;
  
  List<Map<String, String>> get bookedTickets => _bookedTickets;

  // 🎟️ THÊM: Getters cho Voucher
  String? get appliedVoucherCode => _appliedVoucherCode;
  double get discountAmount => _discountAmount;

  String get timerString {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startSeatTimer() {
    if (_countdownTimer != null && _countdownTimer!.isActive) return;

    _isTimeout = false;
    _remainingSeconds = 900; 
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        stopSeatTimer();
        _isTimeout = true;
        clearBooking(); 
        notifyListeners();
      }
    });
  }

  void stopSeatTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  int getFoodQuantity(int foodId) {
    return _foodQuantities[foodId] ?? 0;
  }

  void setMovie(Movie movie) {
    _selectedMovie = movie;
    _selectedSeats.clear();
    _foodQuantities.clear();
    removeVoucher();
    notifyListeners();
  }

  void updateSeats(List<String> seats) {
    _selectedSeats = List.from(seats);
    notifyListeners();
  }

  void incrementFood(int foodId) {
    _foodQuantities[foodId] = getFoodQuantity(foodId) + 1;
    notifyListeners();
  }

  void decrementFood(int foodId) {
    int currentQty = getFoodQuantity(foodId);
    if (currentQty > 0) {
      _foodQuantities[foodId] = currentQty - 1;
      notifyListeners();
    }
  }

  int get totalTicketPrice => _selectedSeats.length * _ticketPrice;

  int get totalFoodPrice {
    double total = 0;
    for (var food in foodList) {
      int qty = getFoodQuantity(food.id);
      total += qty * food.price;
    }
    return total.toInt();
  }

  // 🎟️ THÊM: Tổng tiền gốc (Vé + Bắp nước chưa trừ giảm giá)
  double get subTotal => (totalTicketPrice + totalFoodPrice).toDouble();

  // 🎟️ CẬP NHẬT: Tổng tiền thanh toán (Đã trừ đi số tiền giảm giá)
  int get totalPayment {
    double total = subTotal - _discountAmount;
    return total < 0 ? 0 : total.toInt();
  }

  // 🎟️ THÊM: Hàm kiểm tra và áp dụng mã voucher
  bool applyVoucher(String code) {
    code = code.trim().toUpperCase();

    // Giả lập các mã giảm giá
    if (code == 'CGV10') {
      _appliedVoucherCode = code;
      _discountAmount = subTotal * 0.1; // Giảm 10%
      notifyListeners();
      return true;
    } else if (code == 'DISCOUNT20K') {
      _appliedVoucherCode = code;
      _discountAmount = 20000; // Giảm 20.000đ
      notifyListeners();
      return true;
    }

    return false; // Mã không hợp lệ
  }

  // 🎟️ THÊM: Hàm hủy áp dụng voucher
  void removeVoucher() {
    _appliedVoucherCode = null;
    _discountAmount = 0;
    notifyListeners();
  }

  void addTicket(Map<String, String> newTicket) {
    _bookedTickets.add(newTicket);
    notifyListeners();
  }

  void clearBooking() {
    _selectedMovie = null;
    _selectedSeats.clear();
    _foodQuantities.clear();
    removeVoucher(); // Reset voucher
    
    _remainingSeconds = 0;
    _countdownTimer?.cancel();
    _countdownTimer = null;

    notifyListeners();
  }
}