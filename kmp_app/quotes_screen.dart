import 'package:flutter/material.dart';

import 'package:flutter_app/models/quote.dart';
import 'package:flutter_app/screens/quote_detail_screen.dart';
import 'package:flutter_app/services/quotes_service.dart';
import 'package:flutter_app/widgets/quote_card.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => QuotesScreenState();
}

class QuotesScreenState extends State<QuotesScreen> {
  final QuotesService _quotesService = QuotesService();
  late Future<List<Quote>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  void _loadQuotes() {
    _quotesFuture = _quotesService.getQuotes();
  }

  void refreshQuotes() {
    setState(() {
      _loadQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/cinema.png',
          height: 300,
          width: double.infinity,
          fit: BoxFit.fill,
          semanticLabel: 'Kino-Illustration mit Menschen, die Filme schauen',
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image is not found
            return Container(
              height: 200,
              decoration: const BoxDecoration(color: Color(0xFFF3E5F5)),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie, size: 64, color: Colors.black54),
                    SizedBox(height: 8),
                    Text(
                      'Kino & Filmzitate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        FutureBuilder<List<Quote>>(
          future: _quotesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.format_quote, size: 50),
                    SizedBox(height: 16),
                    Text(
                      'Keine Zitate vorhanden',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8),
                    Text('Fügen Sie Ihre Lieblingszitate aus Filmen hinzu'),
                  ],
                ),
              );
            }
            final quotes = snapshot.data!;
            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return QuoteCard(
                    quote: quote,
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuoteDetailScreen(quote: quote),
                        ),
                      );
                      // Refresh the quotes list if something was changed or deleted
                      if (result != null) {
                        refreshQuotes();
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
