import 'package:flutter/material.dart';

import 'package:flutter_app/models/quote.dart';
import 'package:flutter_app/screens/quote_detail_screen.dart';
import 'package:flutter_app/widgets/star_rating_widget.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onFavoriteToggle;

  const QuoteCard({
    super.key,
    required this.quote,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap:
            onTap ??
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuoteDetailScreen(quote: quote),
                ),
              );
            },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote text with quotation marks
              Text(
                '"${quote.text}"',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Character info with person icon
              if (quote.character != null && quote.character!.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      quote.character!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.movie, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      quote.year != null
                          ? '${quote.movie} (${quote.year})'
                          : quote.movie,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Rating display (only show if rating exists and is > 1)
              const SizedBox(height: 12),
              StarRatingWidget(
                rating: quote.rating,
                starSize: 16.0,
                isEditable: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
