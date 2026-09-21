import 'package:flutter/material.dart';
import '../model/movie.dart';

class MovieItem extends StatelessWidget {

  final Movie movie;

  const MovieItem({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(

      leading: Image.asset(movie.image,width:60),

      title: Text(movie.title),

      subtitle: Text(movie.genre),

      trailing: Text("${movie.duration} phút"),

    );

  }

}