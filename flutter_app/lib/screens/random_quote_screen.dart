import 'dart:math';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'package:flutter_app/models/quote.dart';
import 'package:flutter_app/services/quotes_service.dart';
import 'package:flutter_app/widgets/quote_card.dart';

class RandomQuoteScreen extends StatefulWidget {
  const RandomQuoteScreen({super.key});

  @override
  State<RandomQuoteScreen> createState() => _RandomQuoteScreenState();
}

class _RandomQuoteScreenState extends State<RandomQuoteScreen> {
  final QuotesService _quotesService = QuotesService();
  late VideoPlayerController _videoPlayerController;
  Quote? _currentQuote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  Future<void> _loadRandomQuote() async {
    setState(() {
      _isLoading = true;
    });
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/cinema.mp4')
          ..initialize().then((_) {
            setState(() {
              _videoPlayerController.play();
              _videoPlayerController.setVolume(0);
            });
          });

    try {
      final quotes = await _quotesService.getQuotes();
      if (quotes.isNotEmpty) {
        final random = Random();
        final randomIndex = random.nextInt(quotes.length);
        setState(() {
          _currentQuote = quotes[randomIndex];
        });
      }
    } catch (e) {
      // Handle error
      print('Error loading random quote: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _videoPlayerController.value.isInitialized
                  ? Semantics(
                      label: "Kino-Video mit Szenen aus verschiedenen Filmen",
                      child: SizedBox(
                        height: 300,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    )
                  : const SizedBox.shrink(),
              // Random Quote Card
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_currentQuote != null)
                QuoteCard(quote: _currentQuote!)
              else
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 50,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Keine Zitate vorhanden',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fügen Sie Ihr erstes Zitat hinzu!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Refresh Button (Get Another Random Quote)
              if (_currentQuote != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _loadRandomQuote,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Anderes Zitat', style: TextStyle()),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
