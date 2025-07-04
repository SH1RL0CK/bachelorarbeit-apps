import 'package:flutter/material.dart';

import 'package:flutter_app/models/quote.dart';
import 'package:flutter_app/services/quotes_service.dart';
import 'package:flutter_app/widgets/star_rating_widget.dart';

class QuoteDetailScreen extends StatefulWidget {
  final Quote quote;

  const QuoteDetailScreen({super.key, required this.quote});

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  final QuotesService _quotesService = QuotesService();
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _movieController = TextEditingController();
  final _characterController = TextEditingController();
  final _yearController = TextEditingController();
  late Quote _currentQuote;
  int _rating = 1; // Default rating

  @override
  void initState() {
    super.initState();
    _currentQuote = widget.quote;
    // Initialize controllers with current quote data
    _textController.text = _currentQuote.text;
    _movieController.text = _currentQuote.movie;
    _characterController.text = _currentQuote.character ?? '';
    _yearController.text = _currentQuote.year?.toString() ?? '';
    _rating = _currentQuote.rating;
  }

  @override
  void dispose() {
    _textController.dispose();
    _movieController.dispose();
    _characterController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _updateRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedQuote = _currentQuote.copyWith(
          text: _textController.text,
          movie: _movieController.text,
          character: _characterController.text.isEmpty
              ? null
              : _characterController.text,
          year: _yearController.text.isEmpty
              ? null
              : int.tryParse(_yearController.text),
          rating: _rating,
        );

        await _quotesService.updateQuote(updatedQuote);

        setState(() {
          _currentQuote = updatedQuote;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Änderungen gespeichert'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(updatedQuote);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Speichern: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteQuote() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zitat löschen'),
        content: const Text('Möchten Sie dieses Zitat wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Löschen', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _quotesService.deleteQuote(_currentQuote.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Zitat gelöscht'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          Navigator.of(context).pop('deleted');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler beim Löschen: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zitat Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote text field
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Zitat*',
                  hintText: 'Geben Sie den Zitat-Text ein',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie den Zitat-Text ein';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Character field
              TextFormField(
                controller: _characterController,
                decoration: const InputDecoration(
                  labelText: 'Charakter',
                  hintText: 'Wer hat das Zitat gesagt?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Movie field
              TextFormField(
                controller: _movieController,
                decoration: const InputDecoration(
                  labelText: 'Film/Serie*',
                  hintText: 'Name des Films oder der Serie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie den Namen des Films ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Year field
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Jahr',
                  hintText: 'z.B. 2004',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),

              // Rating section
              const Text(
                'Zitat bewerten:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Star rating widget
              StarRatingWidget(
                rating: _rating,
                onRatingChanged: _updateRating,
                isEditable: true,
              ),
              const SizedBox(height: 48),

              // Action buttons
              Column(
                children: [
                  // Save changes button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Änderungen speichern',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Delete quote button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _deleteQuote,
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        'Zitat löschen',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
