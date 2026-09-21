import 'package:flutter/material.dart';
import '../model/cinema.dart';

class CinemaCard extends StatelessWidget {

  final Cinema cinema;

  final VoidCallback onTap;

  const CinemaCard({

    super.key,

    required this.cinema,

    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: ListTile(

        onTap: onTap,

        leading: Image.asset(
          cinema.image,
          width: 60,
        ),

        title: Text(cinema.name),

        subtitle: Text(cinema.address),

      ),

    );

  }

}