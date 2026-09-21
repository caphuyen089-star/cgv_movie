class Cinema {
  final int id;
  final String name;
  final String address;
  final String city;
  final String image;

  Cinema({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.image,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'image': image,
    };
  }
}