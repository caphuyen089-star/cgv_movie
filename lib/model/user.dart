class User {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String avatar;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }
}