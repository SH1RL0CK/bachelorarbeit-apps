import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import 'package:flutter_app/models/quote.dart';
import 'package:flutter_app/widgets/star_rating_widget.dart';

class QuoteDialog extends StatefulWidget {
  final Quote? quote;
  final Function(Quote) onSave;

  const QuoteDialog({super.key, this.quote, required this.onSave});

  @override
  State<QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<QuoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _movieController = TextEditingController();
  final _characterController = TextEditingController();
  final _yearController = TextEditingController();
  int _rating = 1;

  @override
  void initState() {
    super.initState();
    if (widget.quote != null) {
      _textController.text = widget.quote!.text;
      _movieController.text = widget.quote!.movie;
      _characterController.text = widget.quote!.character ?? '';
      _yearController.text = widget.quote!.year?.toString() ?? '';
      _rating = widget.quote!.rating;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _movieController.dispose();
    _characterController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.quote == null ? 'Neues Zitat hinzufügen' : 'Zitat bearbeiten',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Zitat Text*',
                  hintText: 'Geben Sie den Zitat-Text ein',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie den Zitat-Text ein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              TextFormField(
                controller: _characterController,
                decoration: const InputDecoration(
                  labelText: 'Charakter',
                  hintText: 'Wer hat das Zitat gesagt?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Erscheinungsjahr',
                  hintText: 'z.B. 1999',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Rating section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bewertung:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              StarRatingWidget(
                rating: _rating,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                starSize: 28.0,
                isEditable: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final quote = Quote(
                id: widget.quote?.id ?? Uuid().v4(),
                text: _textController.text,
                movie: _movieController.text,
                character: _characterController.text.isEmpty
                    ? null
                    : _characterController.text,
                year: _yearController.text.isEmpty
                    ? null
                    : int.tryParse(_yearController.text),
                rating: _rating,
                createdAt: widget.quote?.createdAt ?? DateTime.now(),
              );
              widget.onSave(quote);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Speichern', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
