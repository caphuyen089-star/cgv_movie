import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/movie.dart';
import '../../provider/movie_provider.dart';

class SelectMoviePage extends StatelessWidget {
  const SelectMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<MovieProvider>().movies;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn phim"),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return InkWell(
            onTap: () {
              Provider.of<MovieProvider>(
                context,
                listen: false,
              ).selectMovie(movie);

              Navigator.pushNamed(
                context,
                "/booking",
                arguments: movie,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              child: Row(
                children: [
                  /// Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: movie.image.startsWith("http")
                        ? Image.network(
                            movie.image,
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                             "assets/images/${movie.image}",
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "${movie.duration} phút",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}