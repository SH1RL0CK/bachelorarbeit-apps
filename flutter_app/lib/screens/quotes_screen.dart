import 'package:flutter/material.dart';

import 'package:flutter_app/models/quote.dart';
import 'package:flutter_app/services/quotes_service.dart';
import 'package:flutter_app/widgets/quote_dialog.dart';

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

  Future<void> _addQuote(Quote quote) async {
    await _quotesService.addQuote(quote);
    setState(() {
      _loadQuotes();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zitat erfolgreich hinzugefügt')),
      );
    }
  }

  Future<void> _toggleFavorite(Quote quote) async {
    final updatedQuote = quote.copyWith(
      isFavorite: !(quote.isFavorite ?? false),
    );
    await _quotesService.updateQuote(updatedQuote);
    setState(() {
      _loadQuotes();
    });
  }

  Future<void> _deleteQuote(String id) async {
    await _quotesService.deleteQuote(id);
    setState(() {
      _loadQuotes();
    });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Zitat gelöscht')));
    }
  }

  void refreshQuotes() {
    setState(() {
      _loadQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quote>>(
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
                Text('Keine Zitate vorhanden', style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                Text('Fügen Sie Ihre Lieblingszitate aus Filmen hinzu'),
              ],
            ),
          );
        }

        final quotes = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            final quote = quotes[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.format_quote, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            quote.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            quote.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: quote.isFavorite == true ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(quote),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${quote.movie} ${quote.year != null ? "(${quote.year})" : ""}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (quote.character != null) ...[
                      const SizedBox(height: 4),
                      Text('Character: ${quote.character}'),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteQuote(quote.id!),
                          tooltip: 'Löschen',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
