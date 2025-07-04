import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final Function(int)? onRatingChanged;
  final int maxRating;
  final double starSize;
  final Color activeColor;
  final Color inactiveColor;
  final bool isEditable;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.maxRating = 5,
    this.starSize = 32.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(maxRating, (index) {
        return GestureDetector(
          onTap: isEditable && onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              size: starSize,
              color: index < rating ? activeColor : inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}
