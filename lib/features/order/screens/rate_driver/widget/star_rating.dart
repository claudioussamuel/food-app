import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int starCount;
  final double starSize;
  final Color color;
  final Function(int) onRatingChanged;

  const StarRating({
    super.key,
    this.starCount = 5,
    this.starSize = 30.0,
    this.color = Colors.orange,
    required this.onRatingChanged,
  });

  @override
  StarRatingState createState() => StarRatingState();
}

class StarRatingState extends State<StarRating> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingChanged(_currentRating);
          },
          icon: Icon(
            index < _currentRating ? Icons.star : Icons.star_border,
            color: widget.color,
            size: widget.starSize,
          ),
        );
      }),
    );
  }
}
