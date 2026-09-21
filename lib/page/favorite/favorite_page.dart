import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // Giả lập danh bạ phim yêu thích của user
  final List<Map<String, String>> _favMovies = [
    {'title': 'minions và quái vật', 'image': 'minionvaquaivat.webp', 'duration': '128 phút'},
    {'title': 'Thám Tử Lừng Danh Conan', 'image': 'conan.webp', 'duration': '110 phút'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Phim Muốn Xem', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: _favMovies.isEmpty
          ? const Center(child: Text('Danh sách yêu thích trống', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favMovies.length,
              itemBuilder: (context, index) {
                final item = _favMovies[index];
                return Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(item['image']!, width: 60, height: 90, fit: BoxFit.cover),
                    ),
                    title: Text(item['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text('Thời lượng: ${item['duration']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // Xóa phim khỏi danh sách yêu thích
                        setState(() => _favMovies.removeAt(index));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}