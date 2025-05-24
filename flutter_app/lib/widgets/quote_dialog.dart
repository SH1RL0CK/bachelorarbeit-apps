import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import 'package:flutter_app/models/quote.dart';

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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.quote != null) {
      _textController.text = widget.quote!.text;
      _movieController.text = widget.quote!.movie;
      _characterController.text = widget.quote!.character ?? '';
      _yearController.text = widget.quote!.year?.toString() ?? '';
      _isFavorite = widget.quote!.isFavorite ?? false;
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
                ),
                maxLines: 3,
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
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Erscheinungsjahr',
                  hintText: 'z.B. 1999',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isFavorite,
                    onChanged: (value) {
                      setState(() {
                        _isFavorite = value ?? false;
                      });
                    },
                  ),
                  const Text('Favorit'),
                ],
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
                isFavorite: _isFavorite,
                createdAt: widget.quote?.createdAt ?? DateTime.now(),
              );
              widget.onSave(quote);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
