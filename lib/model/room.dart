class Room {
  final int id;
  final String roomName;
  final int cinemaId;
  final int totalSeat;

  Room({
    required this.id,
    required this.roomName,
    required this.cinemaId,
    required this.totalSeat,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      roomName: json['roomName'],
      cinemaId: json['cinemaId'],
      totalSeat: json['totalSeat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomName': roomName,
      'cinemaId': cinemaId,
      'totalSeat': totalSeat,
    };
  }
}