import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/movie_provider.dart';

class ApproveMoviePage extends StatelessWidget {
  const ApproveMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final movies = movieProvider.movies;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text("Phê Duyệt Phim Phát Hành"),
        backgroundColor: Colors.red[800],
        centerTitle: true,
      ),
      body: movies.isEmpty
          ? const Center(child: Text("Không có phim nào", style: TextStyle(color: Colors.white)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                Color statusColor = Colors.orange;
                String statusText = "Chờ phê duyệt";
                if (movie.status == 'APPROVED') {
                  statusColor = Colors.green;
                  statusText = "Đã phê duyệt";
                } else if (movie.status == 'REJECTED') {
                  statusColor = Colors.red;
                  statusText = "Đã từ chối";
                }

                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/${movie.image}',
                            width: 60,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 80,
                              color: Colors.grey[800],
                              child: const Icon(Icons.movie, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text("Thể loại: ${movie.genre}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  border: Border.all(color: statusColor),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        // 🟢 Các nút bấm Phê duyệt / Từ chối
                        if (movie.status == 'PENDING')
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green, size: 30),
                                onPressed: () async {
                                  bool success = await movieProvider.approveMovie(movie.id, true);
                                  if (context.mounted && success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Đã phê duyệt phim ${movie.title}!")),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
                                onPressed: () async {
                                  bool success = await movieProvider.approveMovie(movie.id, false);
                                  if (context.mounted && success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Đã từ chối phim ${movie.title}!")),
                                    );
                                  }
                                },
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}