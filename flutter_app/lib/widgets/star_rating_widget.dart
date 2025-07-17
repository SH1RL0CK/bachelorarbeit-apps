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
    return Semantics(
      label: 'Bewertung: $rating von $maxRating Sternen',
      value: '$rating/$maxRating',
      hint: isEditable ? 'Tippen um Bewertung zu ändern' : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(maxRating, (index) {
          final starNumber = index + 1;
          final isActive = index < rating;

          return Semantics(
            label: 'Stern $starNumber',
            value: isActive ? 'ausgefüllt' : 'nicht ausgefüllt',
            excludeSemantics: true,
            button: isEditable,
            onTap: isEditable && onRatingChanged != null
                ? () => onRatingChanged!(starNumber)
                : null,
            child: InkWell(
              onTap: isEditable && onRatingChanged != null
                  ? () => onRatingChanged!(starNumber)
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  isActive ? Icons.star : Icons.star_border,
                  size: starSize,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
