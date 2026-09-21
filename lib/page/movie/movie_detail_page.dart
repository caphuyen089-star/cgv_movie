import 'package:flutter/material.dart';
import '../../model/movie.dart';
import '../../widgets/movie_review_widget.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Nội dung chính cuộn được
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Khoảng trống tránh đè nút Mua Vé
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Backdrop phim hình ảnh lớn phía trên
                Stack(
                  children: [
                    movie.image.startsWith('http')
                        ? Image.network(
                            movie.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.white54, size: 40),
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/images/${movie.image}',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.white54, size: 40),
                              ),
                            ),
                          ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8), Colors.black],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Phần thông tin tiêu đề phim
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('${movie.genre} • ${movie.duration} phút', style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text('Nội dung phim', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        movie.description,
                        style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
                      ),

                      const SizedBox(height: 20),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),

                      // Widget Đánh giá phim
                      MovieReviewWidget(movieId: movie.id.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Nút "Mua Vé" cố định ở Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.9),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/booking', arguments: movie);
                },
                child: const Text('MUA VÉ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}