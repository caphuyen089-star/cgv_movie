import 'package:flutter/material.dart';
import '../model/movie.dart';

class MovieCard extends StatelessWidget {

  final Movie movie;

  final VoidCallback onTap;

  const MovieCard({

    super.key,

    required this.movie,

    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Card(

        child: Column(

          children: [

            Image.asset(
              movie.image,
              height: 180,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),

            Text(
              movie.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(movie.genre),

            Text("⭐ ${movie.rating}"),

          ],

        ),

      ),

    );

  }

}