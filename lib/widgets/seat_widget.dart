import 'package:flutter/material.dart';

class SeatWidget extends StatelessWidget {

  final String seat;

  final bool isSelected;

  final bool isBooked;

  final VoidCallback onTap;

  const SeatWidget({

    super.key,

    required this.seat,

    required this.isSelected,

    required this.isBooked,

    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    Color color;

    if (isBooked) {

      color = Colors.grey;

    } else if (isSelected) {

      color = Colors.red;

    } else {

      color = Colors.green;

    }

    return GestureDetector(

      onTap: isBooked ? null : onTap,

      child: Container(

        margin: const EdgeInsets.all(4),

        width: 40,

        height: 40,

        decoration: BoxDecoration(

          color: color,

          borderRadius: BorderRadius.circular(8),

        ),

        alignment: Alignment.center,

        child: Text(

          seat,

          style: const TextStyle(
            color: Colors.white,
          ),

        ),

      ),

    );

  }

}