class Seat {
  final int id;
  final String seatNumber;
  final String row;
  final bool isBooked;
  final bool isVip;

  Seat({
    required this.id,
    required this.seatNumber,
    required this.row,
    required this.isBooked,
    required this.isVip,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      seatNumber: json['seatNumber'],
      row: json['row'],
      isBooked: json['isBooked'],
      isVip: json['isVip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seatNumber': seatNumber,
      'row': row,
      'isBooked': isBooked,
      'isVip': isVip,
    };
  }
}